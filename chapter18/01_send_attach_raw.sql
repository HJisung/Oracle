SET SERVEROUTPUT ON
SET DEFINE OFF

DECLARE
  c_host CONSTANT VARCHAR2(20) := '127.0.0.1';
  c_port CONSTANT PLS_INTEGER := 25252;
  c_crlf CONSTANT VARCHAR2(2) := CHR(13) || CHR(10);
  c_base64 CONSTANT VARCHAR2(64) := 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';

  FUNCTION encode_base64(p_hex VARCHAR2) RETURN VARCHAR2
  IS
    v_result VARCHAR2(76);
    v_byte_count PLS_INTEGER := LENGTH(p_hex) / 2;
    v_second PLS_INTEGER;
    v_third PLS_INTEGER;
    v_group PLS_INTEGER;
  BEGIN
    FOR i IN 0..TRUNC((v_byte_count - 1) / 3) LOOP
      v_second := 3 * i + 2;
      v_third := 3 * i + 3;
      v_group := TO_NUMBER(RPAD(SUBSTR(p_hex, 6 * i + 1, 6), 6, '0'), 'XXXXXX');

      v_result := v_result || SUBSTR(c_base64, 1 + TRUNC(v_group / 262144), 1)
                            || SUBSTR(c_base64, 1 + MOD(TRUNC(v_group / 4096), 64), 1)
                            || CASE WHEN v_second <= v_byte_count
                                    THEN SUBSTR(c_base64, 1 + MOD(TRUNC(v_group / 64), 64), 1)
                                    ELSE '=' END
                            || CASE WHEN v_third <= v_byte_count
                                    THEN SUBSTR(c_base64, 1 + MOD(v_group, 64), 1)
                                    ELSE '=' END;
    END LOOP;
    RETURN v_result;
  END;

  PROCEDURE send_attach_raw(
    sender IN VARCHAR2,
    recipients IN VARCHAR2,
    cc IN VARCHAR2 DEFAULT NULL,
    bcc IN VARCHAR2 DEFAULT NULL,
    subject IN VARCHAR2 DEFAULT NULL,
    message IN VARCHAR2 DEFAULT NULL,
    mime_type IN VARCHAR2 DEFAULT 'text/plain; charset=us-ascii',
    priority IN PLS_INTEGER DEFAULT 3,
    attachment IN RAW,
    att_inline IN BOOLEAN DEFAULT TRUE,
    att_mime_type IN VARCHAR2 DEFAULT 'text/plain; charset=us-ascii',
    att_filename IN VARCHAR2 DEFAULT NULL
  )
  IS
    v_connection UTL_SMTP.connection;
    v_connected BOOLEAN := FALSE;
    v_boundary VARCHAR2(48) := 'CH18_' || RAWTOHEX(SYS_GUID());
    v_disposition VARCHAR2(10) := CASE WHEN att_inline THEN 'inline' ELSE 'attachment' END;
    v_filename VARCHAR2(2000);
    v_pending_hex VARCHAR2(2600);
    v_chunk_hex VARCHAR2(2400);
    v_chunk VARCHAR2(1200);
    v_hex_length PLS_INTEGER := NVL(LENGTH(RAWTOHEX(attachment)), 0);
    v_offset PLS_INTEGER := 1;

    PROCEDURE validate_header(p_value VARCHAR2) IS
    BEGIN
      IF INSTR(p_value, CHR(13)) > 0 OR INSTR(p_value, CHR(10)) > 0
         OR LENGTHB(p_value) > 900 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Invalid MIME header value.');
      END IF;
    END;

    PROCEDURE write_line(p_line VARCHAR2) IS
    BEGIN
      UTL_SMTP.WRITE_DATA(v_connection, p_line || c_crlf);
    END;

    PROCEDURE add_recipients(p_list VARCHAR2) IS
      v_start PLS_INTEGER := 1;
      v_end PLS_INTEGER;
    BEGIN
      WHILE v_start <= LENGTH(p_list) LOOP
        v_end := INSTR(p_list || ',', ',', v_start);
        UTL_SMTP.RCPT(v_connection, TRIM(SUBSTR(p_list, v_start, v_end - v_start)));
        v_start := v_end + 1;
      END LOOP;
    END;
  BEGIN
    validate_header(sender);
    validate_header(recipients);
    validate_header(cc);
    validate_header(bcc);
    validate_header(subject);
    validate_header(mime_type);
    validate_header(att_mime_type);
    validate_header(att_filename);
    IF sender IS NULL OR recipients IS NULL OR attachment IS NULL
       OR priority NOT BETWEEN 1 AND 5 THEN
      RAISE_APPLICATION_ERROR(-20001, 'Sender, recipients and attachment are required. Use priority 1 to 5.');
    END IF;

    IF att_filename IS NOT NULL THEN
      v_filename := '; filename="' || REPLACE(REPLACE(att_filename, '\', '\\'), '"', '\"') || '"';
      validate_header(v_filename);
    END IF;

    v_connection := UTL_SMTP.OPEN_CONNECTION(c_host, c_port, 10);
    v_connected := TRUE;
    UTL_SMTP.HELO(v_connection, 'oracle-course.local');
    UTL_SMTP.MAIL(v_connection, sender);
    add_recipients(recipients);
    add_recipients(cc);
    add_recipients(bcc);
    UTL_SMTP.OPEN_DATA(v_connection);

    write_line('Date: ' || TO_CHAR(SYSTIMESTAMP, 'Dy, DD Mon YYYY HH24:MI:SS TZHTZM', 'NLS_DATE_LANGUAGE=English'));
    write_line('From: ' || sender);
    write_line('To: ' || recipients);
    IF cc IS NOT NULL THEN
      write_line('Cc: ' || cc);
    END IF;
    IF subject IS NOT NULL THEN
      write_line('Subject: ' || subject);
    END IF;
    IF priority IS NOT NULL THEN
      write_line('X-Priority: ' || priority);
    END IF;
    write_line('MIME-Version: 1.0');
    write_line('Content-Type: multipart/mixed; boundary="' || v_boundary || '"');
    write_line(NULL);

    write_line('--' || v_boundary);
    write_line('Content-Type: ' || mime_type);
    write_line('Content-Transfer-Encoding: base64');
    write_line(NULL);
    WHILE v_offset <= LENGTH(message) LOOP
      v_chunk := SUBSTR(message, v_offset, 300);
      SELECT RAWTOHEX(v_chunk) INTO v_chunk_hex FROM dual;
      v_pending_hex := v_pending_hex || v_chunk_hex;
      WHILE LENGTH(v_pending_hex) >= 114 LOOP
        write_line(encode_base64(SUBSTR(v_pending_hex, 1, 114)));
        v_pending_hex := SUBSTR(v_pending_hex, 115);
      END LOOP;
      v_offset := v_offset + 300;
    END LOOP;
    IF v_pending_hex IS NOT NULL THEN
      write_line(encode_base64(v_pending_hex));
    END IF;

    write_line('--' || v_boundary);
    write_line('Content-Type: ' || att_mime_type);
    write_line('Content-Disposition: ' || v_disposition || v_filename);
    write_line('Content-Transfer-Encoding: base64');
    write_line(NULL);
    FOR i IN 0..TRUNC((v_hex_length - 1) / 114) LOOP
      write_line(encode_base64(SUBSTR(RAWTOHEX(attachment), i * 114 + 1, 114)));
    END LOOP;
    write_line('--' || v_boundary || '--');

    UTL_SMTP.CLOSE_DATA(v_connection);
    UTL_SMTP.QUIT(v_connection);
  EXCEPTION
    WHEN OTHERS THEN
      IF v_connected THEN
        BEGIN
          UTL_SMTP.CLOSE_CONNECTION(v_connection);
        EXCEPTION
          WHEN OTHERS THEN NULL;
        END;
      END IF;
      RAISE;
  END;
BEGIN
  send_attach_raw(
    sender       => 'sender@example.invalid',
    recipients   => 'recipient@example.invalid',
    cc           => 'copy@example.invalid',
    bcc          => 'blind@example.invalid',
    subject      => 'Chapter 18 RAW attachment',
    message      => 'Oracle SMTP attachment test.',
    attachment   => HEXTORAW('0001FEFF'),
    att_inline   => FALSE,
    att_mime_type => 'application/octet-stream',
    att_filename => 'sample.bin'
  );
END;
/

SET DEFINE ON
