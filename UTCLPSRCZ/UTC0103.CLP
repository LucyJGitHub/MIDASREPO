/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas UT Delete dependent logical files')             */
/*********************************************************************/
/*                                                                   */
/*       Midas - Utilities Module                                    */
/*                                                                   */
/*       UTC0103 - Delete Dependent Logical Files                    */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*       Prev Amend No. BG18886            Date 21May08              */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      S01526  *CREATE    Date 13Nov95              */
/*                      Xnnnnn             Date ddmmmyy              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       BG18886 - Amend non-standard codes                          */
/*       S01526 - Created for the Midas Upgrade Utility              */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&PFILLIB)
 
/*    Parameter                                                    */
 
             DCL        VAR(&PFILLIB) TYPE(*CHAR) LEN(20)
             DCL        VAR(&PFILE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PFLIB) TYPE(*CHAR) LEN(10)
 
/*    Work variables - generic user space variables                */
 
             DCL        VAR(&USRSPC) TYPE(*CHAR) LEN(20) +
                          VALUE('DBRLIST   QTEMP     ')
             DCL        VAR(&ATTRIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&AUTH) TYPE(*CHAR) LEN(10) VALUE('*ALL')
             DCL        VAR(&GENHDR) TYPE(*CHAR) LEN(140)
             DCL        VAR(&COUNT) TYPE(*DEC) LEN(5 0)
             DCL        VAR(&ENTCNT) TYPE(*DEC) LEN(8 0)
             DCL        VAR(&ENTCNTB) TYPE(*CHAR) LEN(4)
             DCL        VAR(&ENTLENB) TYPE(*CHAR) LEN(4)
             DCL        VAR(&OFFSETB) TYPE(*CHAR) LEN(4)
             DCL        VAR(&STRPOSB) TYPE(*CHAR) LEN(4)
             DCL        VAR(&ERRCDE) TYPE(*DEC) LEN(4 0)
 
/*    Work variables particular to QDBLDBR API                     */
 
             DCL        VAR(&PFMBR) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PFFMT) TYPE(*CHAR) LEN(10)
             DCL        VAR(&DBRENT) TYPE(*CHAR) LEN(48)
             DCL        VAR(&LFILE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&LFLIB) TYPE(*CHAR) LEN(10)
 
             DCL        VAR(&MSGF) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MSGID) TYPE(*CHAR) LEN(7)
             DCL        VAR(&MSGDTA) TYPE(*CHAR) LEN(128)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
/*    Global monitor message                                         */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ERROR))
 
/*    Check for physical file                                      */
 
             CHGVAR     VAR(&PFILE) VALUE(%SST(&PFILLIB 1 10))
             CHGVAR     VAR(&PFLIB) VALUE(%SST(&PFILLIB 11 10))
             CHKOBJ     OBJ(&PFLIB/&PFILE) OBJTYPE(*FILE)
 
/*    Create user space to contain dependent LFs list              */
 
             CALL QUSCRTUS                                          +
                  (&USRSPC                                          +
                   &ATTRIB                                          +
                   X'00000400'                                      +
                   ' '                                              +
                   &AUTH                                            +
                   'DLTDEPLF Database Relations List User Space')
             MONMSG     MSGID(CPF9870) EXEC(RCVMSG MSGTYPE(*LAST))
 
/*    Generate database relations list                             */
 
             CALL QDBLDBR                                           +
                  (&USRSPC                                          +
                   'DBRL0100'                                       +
                   &PFILLIB                                         +
                   &PFMBR                                           +
                   &PFFMT                                           +
                   &ERRCDE)
             MONMSG     MSGID(CPF0000)
 
/*    Read generic header from user space                          */
 
             CALL       PGM(QUSRTVUS) PARM(&USRSPC X'00000001' +
                          X'0000008C' &GENHDR)
             MONMSG     MSGID(CPF0000)
 
/*    Retrieve number of list entries                              */
/*    Retrieve list entry length and offset.                       */
/*    Calculate starting position.                                 */
 
             CHGVAR     VAR(&ENTCNTB) VALUE(%SST(&GENHDR 133 4))
             CHGVAR     VAR(&ENTCNT) VALUE(%BIN(&ENTCNTB))
             CHGVAR     VAR(&ENTLENB) VALUE(%SST(&GENHDR 137 4))
             CHGVAR     VAR(&OFFSETB) VALUE(%SST(&GENHDR 125 4))
             CHGVAR     VAR(%BIN(&STRPOSB)) VALUE(%BIN(&OFFSETB) + 1)
 
/*    Read through list                                            */
 
 LOOP:
             CHGVAR     &COUNT (&COUNT + 1)
             IF         (&COUNT <= &ENTCNT) DO
               CALL       PGM(QUSRTVUS) PARM(&USRSPC &STRPOSB +
                            &ENTLENB &DBRENT)
 
/*    Delete dependent file                                        */
 
               CHGVAR     VAR(&LFILE) VALUE(%SST(&DBRENT 21 10))
               CHGVAR     VAR(&LFLIB) VALUE(%SST(&DBRENT 31 10))
/**********    IF         COND(&LFILE**= '*NONE') THEN(DO)                            */ /*BG18886*/
               IF         COND(&LFILE *NE '*NONE') THEN(DO)                              /*BG18886*/
                 DLTF       FILE(&LFLIB/&LFILE)
                 MONMSG     MSGID(CPF2105)
               ENDDO
 
/*    Read next entry from user space                              */
 
               CHGVAR     VAR(%BIN(&STRPOSB)) +
                            VALUE(%BIN(&STRPOSB) + %BIN(&ENTLENB))
               GOTO       CMDLBL(LOOP)
             ENDDO
 
             RETURN
 
ERROR:
             RCVMSG     MSGTYPE(*EXCP) MSGDTA(&MSGDTA) MSGID(&MSGID) +
                          MSGF(&MSGF)
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000)
             SNDPGMMSG  MSGID(&MSGID) MSGF(&MSGF) MSGDTA(&MSGDTA) +
                          MSGTYPE(*ESCAPE)
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000)
 
 ENDPGM:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
