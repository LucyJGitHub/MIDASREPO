/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas SE EXTEL interface database reformat')          */
/********************************************************************/
/*                                                                  */
/*    Midas - Securities Trading Module                             */
/*                                                                  */
/*    SE3100 - EXTEL Database Reformat                              */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/*       Last Amend No. CLE134             Date 01Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*       Prev Amend No. BG18886            Date 20May08              */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4.01.02 --------------------------------------------*/
/*                      207764             Date 23Jul02              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                  S01117                   Date 10Jan91           */
/*                  E21146                   Date 13MAR90           */
/*                  E16834                   Date 21/02/89          */
/*                  S01179                   Date 16/09/88          */
/*                                                                  */
/*------------------------------------------------------------------*/
/*                                                                  */
/*    Description of Amendment.                                     */
/*       CLE134 - Past Due Call Loan Processing (Recompile)         */
/*    BG18886 - Amendment of non-standard codes.                    */
/*        207764 - Change all SAV* and RST* commands to print a     */
/*                 report of objects saved or restored.             */
/*    NO. S01117     TEXT:    MULTIBRANCHING                        */
/*    No. E21146     Text:    REPLACE QCAEXEC WITH QCMDEXC          */
/*    No. E16834     Text:    CLEAR COPY DATABASE FILE AT END OF    */
/*                            PROGRAM, ALSO APPLY FIX TO ALLOW FOR  */
/*                            DATA READ IN FROM TWO TAPES.          */
/*    No. S01179     Text:    AS  - RELEASE                         */
/*                                                                  */
/*                                                                  */
/*                                                                  */
/********************************************************************/
/*                                                                  */
/*   POSITION OF TAGS.                                              */
/*                                                                  */
/*     P1001  - ATTEMPTED BACKUP OF CURRENT DATABASE.               */
/*     P1002  - RESTORE NEW DATABASE FROM TAPE.                     */
/*     P9001  - REFORMAT COPY DATABASE.                             */
/*     P9002  - ABORT.                                              */
/*                                                                  */
/********************************************************************/
/*                                                                   */
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
/*                                                                  */
PGM
/*                                                                  */
/********************************************************************/
/*                                                                  */
/*   FUNCTION OF VARIABLES.                                         */
/*                                                                  */
/*     &DATA  - INFORMATION ABOUT DATABASE ERRORS.                  */
/*     &REPLY - REPLY TO ERROR MESSAGES Y OR N.                     */
/*     &CMD1  - PASS IMFORMATION TO SAVOBJ COMMAND.                 */
/*     &TDEV  - TAPE DEVICE NAME TAKEN FROM SAVOBJ COMMAND.         */
/*                                                                  */
/********************************************************************/
/*                                                                  */
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/**/                                                                  /*S01117*/
/************DCL        VAR(&DATA)  TYPE(*CHAR) LEN(44)              * *S01117*/
             DCL        VAR(&DATA)  TYPE(*CHAR) LEN(50)               /*S01117*/
             DCL        VAR(&REPLY)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&CMD1) TYPE(*CHAR) LEN(150)
             DCL        VAR(&TDEV) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MSG1) TYPE(*CHAR) LEN(22) VALUE('Change +
                          tape in device ')
             DCL        VAR(&MSG2) TYPE(*CHAR) LEN(15) VALUE(' to +
                          EXTEL tape.')
             DCL        VAR(&MSG3) TYPE(*CHAR) LEN(80)
             DCL        VAR(&MSG4) TYPE(*CHAR) LEN(30) VALUE(' to +
                          tape used to save objects.')
             DCL        VAR(&MSG5) TYPE(*CHAR) LEN(80)
             DCL        VAR(&MSG6) TYPE(*CHAR) LEN(39) VALUE('Error +
                          on SAVOBJ command on tape device ')
             DCL        VAR(&MSG7) TYPE(*CHAR) LEN(27) VALUE('.Do you +
                          wish to retry Y N ?')
             DCL        VAR(&MSG8) TYPE(*CHAR) LEN(80)
             DCL        VAR(&MSG9) TYPE(*CHAR) LEN(21) VALUE('Error +
                          on tape device ')
             DCL        VAR(&MSG10) TYPE(*CHAR) LEN(80)
             DCL        VAR(&MSG11) TYPE(*CHAR) LEN(39) VALUE('Error +
                          on RSTOBJ command on tape device ')
/*                                                                  */
/********************************************************************/
/*                                                                  */
/*   FUNCTION OF VARIABLES : USED IN 'QCLSCAN' COMMAND.             */
/*                                                                  */
/********************************************************************/
/*                                                                  */
             DCL        VAR(&STRING) TYPE(*CHAR) LEN(150)
             DCL        VAR(&STRLEN) TYPE(*DEC) LEN(3 0)
             DCL        VAR(&STRPOS) TYPE(*DEC) LEN(3 0) VALUE(1)
             DCL        VAR(&PATTERN) TYPE(*CHAR) LEN(4)
             DCL        VAR(&PATLEN) TYPE(*DEC) LEN(3 0)
             DCL        VAR(&TRANSLATE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&TRIM) TYPE(*CHAR) LEN(1)
             DCL        VAR(&WILD) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RESULT) TYPE(*DEC) LEN(3 0)
             DCL        VAR(&ERR) TYPE(*CHAR) LEN(1)
/*                                                                  */
/********************************************************************/
/*                                                                  */
/*   FUNCTION OF LDA.                                               */
/*                                                                  */
/*        LDA - CONTAINS VARIABLE &DATA FOR DATABASE ERRORS         */
/*                                                                  */
/********************************************************************/
/*                                                                  */
/*********   DCLDTAARA  DTAARA(LDA)                          ********  *S01179*/
             DCL        VAR(&LDA) TYPE(*CHAR) LEN(256)                /*S01179*/
/*                                                                  */
/*      Reset database error switches.                              */
/*                                                                  */
             CHGJOB     SWS(XXXXXX00)
/*                                                                  */
/********************************************************************/
/*                                                                  */
/*       Call program to allow entry of SAVOBJ command.             */
/*                                                                  */
 P1001:                                                                                   /*207764*/
/*P1001:*****CHGVAR     VAR(&CMD1) VALUE('savobj ?*obj(excdbd excdf4a + */                /*207764*/
 /**********              excdf4b excdf4c excdf4d excdf4e excdf4f +     */                /*207764*/
 /**********              excdf4g excdf4h excdf4i excdf4j excdf4k +     */                /*207764*/
 /**********              excdf4L) ??lib() ??dev()')                    */                /*207764*/
             CHGVAR     VAR(&CMD1) VALUE('savobj ?*obj(excdbd +
                          excdf4a excdf4b excdf4c excdf4d excdf4e +
                          excdf4f excdf4g excdf4h excdf4i excdf4j +
                          excdf4k excdf4L) ??lib() ??dev() +
                          OUTPUT(*PRINT)')                                                /*207764*/
/*                                                                  */
             CHGVAR VAR(&ERR) VALUE('N')
/*                                                                  */
/**********  CALL       PGM(QCACHECK) PARM(&CMD1 150) */                                  /*207764*/
             CALL       PGM(QCACHECK) PARM(&CMD1 165)                                     /*207764*/
/*                                                                  */
/*    If CMD1 is taken from SAVOBJ command program will abort.      */
/*                                                                  */
             MONMSG     MSGID(CPF6801) EXEC(GOTO CMDLBL(P9002))
/*                                                                  */
/*       If error on command allow user to either try again or      */
/*         terminate program.                                       */
/*                                                                  */
             MONMSG     MSGID(CPF0000 MCH0000 CPA0000 CPD0000) +
                          EXEC(DO)
               CHGVAR VAR(&ERR) VALUE('Y')
             ENDDO
 /*                                                                 */
 /*    Extract the tape device name entered using the 'QCASCAN'     */
 /*       program.The device name is placed in the variable &TDEV   */
 /*                                                                 */
             CHGVAR     VAR(&STRING) VALUE(&CMD1)
             CHGVAR     VAR(&STRLEN) VALUE(150)
             CHGVAR     VAR(&PATTERN) VALUE('DEV(')
             CHGVAR     VAR(&PATLEN) VALUE(4)
 /*                                                                 */
 /*    Scan for string 'DEV('                                       */
 /*                                                                 */
             CALL       PGM(QCLSCAN) PARM(&STRING &STRLEN &STRPOS +
                          &PATTERN &PATLEN &TRANSLATE &TRIM &WILD +
                          &RESULT)
 /*                                                                 */
             IF COND(&RESULT *LE 0) THEN(DO)
               CHGVAR  VAR(&TDEV) VALUE('QDKT      ')
               GOTO SAV
             ENDDO
 /*                                                                 */
             CHGVAR &RESULT (&RESULT+4)
             CHGVAR VAR(&STRING) VALUE(%SST(&CMD1 &RESULT 11))
             CHGVAR     VAR(&STRLEN) VALUE(11)
             CHGVAR     VAR(&PATTERN) VALUE(')')
             CHGVAR     VAR(&PATLEN) VALUE(1)
/*                                                                  */
/*     Scan for string ')'                                          */
/*                                                                  */
             CALL       PGM(QCLSCAN) PARM(&STRING &STRLEN &STRPOS +
                          &PATTERN &PATLEN &TRANSLATE &TRIM &WILD +
                          &RESULT)
 /*                                                                 */
             IF COND(&RESULT *LE 0) THEN(DO)
               CHGVAR  VAR(&TDEV) VALUE('QDKT      ')
               GOTO SAV
             ENDDO
 /*                                                                 */
             CHGVAR &RESULT (&RESULT-1)
             CHGVAR VAR(&TDEV) VALUE(%SST(&STRING 1 &RESULT))
 
/*                                                                  */
/*    If error on SAVOBJ command, send message.                     */
/*                                                                  */
             IF COND(&ERR *EQ 'Y') THEN(DO)
/**********  CHGVAR VAR(&MSG5) VALUE(&MSG6****&TDEV****&MSG7)                        */ /*BG18886*/
             CHGVAR VAR(&MSG5) VALUE(&MSG6 *CAT &TDEV *TCAT &MSG7)                      /*BG18886*/
             SNDUSRMSG  MSG(&MSG5) VALUES('y' 'Y' 'n' 'N') +
                          MSGRPY(&REPLY)
               IF         COND((&REPLY *EQ 'y') *OR (&REPLY *EQ 'Y')) +
                            THEN(GOTO CMDLBL(P1001))
               IF         COND((&REPLY *EQ 'n') *OR (&REPLY *EQ 'N')) +
                            THEN(GOTO CMDLBL(P9002))
             ENDDO
/*                                                                  */
/*       Call program to execute the SAVOBJ command.                */
/*                                                                  */
/*****SAV:         CALL       PGM(QCAEXEC) PARM(&CMD1 150)         */ /*E21146*/
SAV:         CALL       PGM(QCMDEXC) PARM(&CMD1 150)                  /*E21146*/
/*                                                                  */
/*    If CMD1 is taken from the SAVOBJ command program will abort   */
/*                                                                  */
             MONMSG     MSGID(CPF6801) EXEC(GOTO CMDLBL(P9002))
/*                                                                  */
/*       If error on command allow user to either try again or      */
/*         terminate program.                                       */
/*                                                                  */
             MONMSG     MSGID(CPF0000 MCH0000 CPA0000 CPD0000) EXEC(DO)
/**********  CHGVAR VAR(&MSG5) VALUE(&MSG6****&TDEV****&MSG7)                         */ /*BG18886*/
             CHGVAR VAR(&MSG5) VALUE(&MSG6 *CAT &TDEV *TCAT &MSG7)                       /*BG18886*/
             SNDUSRMSG  MSG(&MSG5) VALUES('y' 'Y' 'n' 'N') +
                          MSGRPY(&REPLY)
               IF         COND((&REPLY *EQ 'y') *OR (&REPLY *EQ 'Y')) +
                            THEN(GOTO CMDLBL(P1001))
               IF         COND((&REPLY *EQ 'n') *OR (&REPLY *EQ 'N')) +
                            THEN(GOTO CMDLBL(P9002))
             ENDDO
/*                                                                  */
/********************************************************************/
/*                                                                  */
/*       Clear new database file.                                   */
/*                                                                  */
 P1000X:     DLTF       FILE(QTEMP/NEXTAPFL)                          /*E16834*/
             MONMSG     MSGID(CPF0000)                                /*E16834*/
             DLTF       FILE(QTEMP/NEXTAPF2)                          /*E16834*/
             MONMSG     MSGID(CPF0000)                                /*E16834*/
             CLRPFM     FILE(NEXCDB)
/*                                                                  */
/*       Send message to promt tape change to EXTEL tape.           */
/*                                                                  */
/**********  CHGVAR VAR(&MSG3) VALUE(&MSG1****&TDEV****&MSG2)                         */ /*BG18886*/
             CHGVAR VAR(&MSG3) VALUE(&MSG1 *CAT &TDEV *TCAT &MSG2)                       /*BG18886*/
 P1002A:     SNDUSRMSG  MSG(&MSG3) MSGTYPE(*INFO)
/*                                                                  */
/*       Check that tape device is ready.If there is an error,      */
/*         allow a retry or an abort.                               */
/*                                                                  */
             CHKTAP     DEV(&TDEV)
/*                                                                  */
             MONMSG     MSGID(CPF0000 CPD0000 CPA0000 MCH0000) EXEC(DO)
/**********  CHGVAR VAR(&MSG8) VALUE(&MSG9****&TDEV****&MSG7)                         */ /*BG18886*/
             CHGVAR VAR(&MSG8) VALUE(&MSG9 *CAT &TDEV *TCAT &MSG7)                       /*BG18886*/
             SNDUSRMSG  MSG(&MSG8) VALUES('y' 'Y' 'n' 'N') +
                          MSGRPY(&REPLY)
               IF         COND((&REPLY *EQ 'y   ') *OR (&REPLY *EQ 'Y +
                            ')) THEN(GOTO CMDLBL(P1002A))
               IF         COND((&REPLY *EQ 'n   ') *OR (&REPLY *EQ 'N +
                            ')) THEN(GOTO CMDLBL(P9002))
             ENDDO
/*                                                                  */
/*       Create tape device file.                                   */
/*                                                                  */
             CRTTAPF    FILE(QTEMP/NEXTAPFL) DEV(&TDEV) REELS(*NL) +
                          BLKLEN(1895) RCDBLKFMT(*U) DENSITY(6250)
/*                                                                  */
/*       Copy from tape file to new database file.                  */
/*                                                                  */
 P1002:      CPYF       FROMFILE(NEXTAPFL) TOFILE(NEXCDB) +
                          MBROPT(*REPLACE) FMTOPT(*NOCHK)
/*                                                                  */
/*       If error on command allow user to either try again or      */
/*         abort.                                                   */
/*                                                                  */
             MONMSG     MSGID(CPF0000 MCH0000 CPA0000 CPD0000) EXEC(DO)
               SNDUSRMSG  MSG('Error occurred on CPYF command. Do you +
                            wish to retry  y or n ?') VALUES('y' 'Y' +
                            'n' 'N') MSGRPY(&REPLY)
               IF         COND((&REPLY *EQ 'y   ') *OR (&REPLY *EQ 'Y +
                            ')) THEN(GOTO CMDLBL(P1002))
               IF         COND((&REPLY *EQ 'n   ') *OR (&REPLY *EQ 'N +
                            ')) THEN(GOTO CMDLBL(P9001))
             ENDDO
/*                                                                 */ /*E16834*/
/*    SEND MESSAGE TO PROMPT TAPE CHANGE TO EXTEL                  */ /*E16834*/
/*                                                                 */ /*E16834*/
/**********  CHGVAR     VAR(&MSG3) VALUE(*MSG1****&TDEV****&MSG2)              */ /*E16834 BG18886*/
             CHGVAR     VAR(&MSG3) VALUE(*MSG1 *CAT &TDEV *TCAT &MSG2)            /*E16834 BG18886*/
 P1002X:     SNDUSRMSG  MSG(&MSG3) MSGTYPE(*INQ)                      /*E16834*/
/*                                                                 */ /*E16834*/
/*    CHECK THAT TAPE DEVICE IS READY.IF THERE IS AN ERROR,        */ /*E16834*/
/*      ALLOW A RETRY OR AN ABORT.                                 */ /*E16834*/
/*                                                                 */ /*E16834*/
             CHKTAP     DEV(&TDEV)                                    /*E16834*/
/*                                                                 */ /*E16834*/
             MONMSG   MSGID(CPF0000 CPD0000 CPA0000 MCH0000) EXEC(DO) /*E16834*/
/**********  CHGVAR     VAR(&MSG8) VALUE(*MSG9****&TDEV****&MSG7)              */ /*E16834 BG18886*/
             CHGVAR     VAR(&MSG8) VALUE(*MSG9 *CAT &TDEV *TCAT &MSG7)            /*E16834 BG18886*/
             SNDUSRMSG  MSG(&MSG8) VALUES('y' 'Y' 'n' 'N') +
                              MSGRPY(&REPLY)                          /*E16834*/
             IF       COND((&REPLY *EQ 'y') *OR (&REPLY *EQ 'Y')) +
                              THEN(GOTO CMDLBL(P1002X))               /*E16834*/
             IF       COND((&REPLY *EQ 'n') *OR (&REPLY *EQ 'N')) +
                              THEN(GOTO CMDLBL(P9002))                /*E16834*/
             ENDDO                                                    /*E16834*/
/*                                                                 */ /*E16834*/
/*    CREATE TAPE DEVICE FILE                                      */ /*E16834*/
/*                                                                 */ /*E16834*/
             CRTTAPF  FILE(QTEMP/NEXTAPF2) DEV(&TDEV) REELS(*NL)  +
                        BLKLEN(1895) RCDBLKFMT(*U) DENSITY(6250)      /*E16834*/
/*                                                                 */ /*E16834*/
/*    CREATE TAPE DEVICE FILE 2                                    */ /*E16834*/
/*                                                                 */ /*E16834*/
P1002Y:      CPYF     FROMFILE(NEXTAPF2) TOFILE(NEXCDB) +
                        MBROPT(*ADD) FMTOPT(*NOCHK)                   /*E16834*/
/*                                                                 */ /*E16834*/
/*    IF ERROR ON COMMAND ALLOW USER TO EITHER TRY AGAIN OR        */ /*E16834*/
/*      ABORT.                                                     */ /*E16834*/
/*                                                                 */ /*E16834*/
             MONMSG   MSGID(CPF0000 CPD0000 CPA0000 MCH0000) EXEC(DO) /*E16834*/
             SNDUSRMSG  MSG('Error occurred on CPYF command. Do you +
                          wish to retry FROM THE FIRST TAPE y or n +
                          ?') VALUES('y' 'Y' 'n' 'N') MSGRPY(&REPLY)  /*E16834*/
             IF       COND((&REPLY *EQ 'y') *OR (&REPLY *EQ 'Y')) +
                              THEN(GOTO CMDLBL(P1000X))               /*E16834*/
             IF       COND((&REPLY *EQ 'n') *OR (&REPLY *EQ 'N')) +
                              THEN(GOTO CMDLBL(P9001))                /*E16834*/
             ENDDO                                                    /*E16834*/
/*                                                                  */
/********************************************************************/
/*                                                                  */
/*       Clear copy database files.                                 */
/*                                                                  */
             CLRPFM     FILE(EXCDBD)
             CLRPFM     FILE(EXCDF4A)
             CLRPFM     FILE(EXCDF4B)
             CLRPFM     FILE(EXCDF4C)
             CLRPFM     FILE(EXCDF4D)
             CLRPFM     FILE(EXCDF4E)
             CLRPFM     FILE(EXCDF4F)
             CLRPFM     FILE(EXCDF4G)
             CLRPFM     FILE(EXCDF4H)
             CLRPFM     FILE(EXCDF4I)
             CLRPFM     FILE(EXCDF4J)
             CLRPFM     FILE(EXCDF4K)
             CLRPFM     FILE(EXCDF4L)
/*                                                                  */
/*       Call program to reformat EXTEL copy database.              */
/*                                                                  */
             CALL       PGM(SE3100)
/*                                                                  */
/*       Check for database errors trapped by the program,          */
/*         send program message and abort.                          */
/*                                                                  */
             IF   COND(%SWITCH(XXXXXX11))   THEN(DO)
/**************RTVDTAARA   DTAARA(LDA (134 44))   RTNVAR(&DATA)      * *S01117*/
               RTVDTAARA   DTAARA(LDA (134 50))   RTNVAR(&DATA)       /*S01117*/
               SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&DATA) +
                           TOPGMQ(*EXT) TOMSGQ(MOPERQ)
               GOTO       CMDLBL(P9001)
             ENDDO
/*                                                                  */
/*       Check for file controls errors and                         */
/*         send program message.                                    */
/*                                                                  */
             IF   COND(%SWITCH(XXXXXX01))   THEN(DO)
/**************RTVDTAARA   DTAARA(LDA (168 8))   RTNVAR(&DATA)       * *S01117*/
               RTVDTAARA   DTAARA(LDA (171 10))   RTNVAR(&DATA)       /*S01117*/
               SNDPGMMSG  MSGID(MEM0002) MSGF(MIDAS) MSGDTA(&DATA) +
                            TOPGMQ(*EXT) TOMSGQ(MOPERQ)
               GOTO       CMDLBL(P9001)
             ENDDO
/*                                                                  */
             GOTO ENDPGM
/*                                                                  */
/********************************************************************/
/*                                                                  */
/*       Clear copy database files.                                 */
/*                                                                  */
 P9001:      CLRPFM     FILE(EXCDBD)
             CLRPFM     FILE(EXCDF4A)
             CLRPFM     FILE(EXCDF4B)
             CLRPFM     FILE(EXCDF4C)
             CLRPFM     FILE(EXCDF4D)
             CLRPFM     FILE(EXCDF4E)
             CLRPFM     FILE(EXCDF4F)
             CLRPFM     FILE(EXCDF4G)
             CLRPFM     FILE(EXCDF4H)
             CLRPFM     FILE(EXCDF4I)
             CLRPFM     FILE(EXCDF4J)
             CLRPFM     FILE(EXCDF4K)
             CLRPFM     FILE(EXCDF4L)
/*                                                                  */
/*       Send message to promt tape change to original tape.        */
/*                                                                  */
/**********  CHGVAR VAR(&MSG3) VALUE(&MSG1****&TDEV****&MSG4)                         */ /*BG18886*/
             CHGVAR VAR(&MSG3) VALUE(&MSG1 *CAT &TDEV *TCAT &MSG4)                       /*BG18886*/
 P9001A:     SNDUSRMSG  MSG(&MSG3) MSGTYPE(*INFO)
/*                                                                  */
/*       Check that tape device is ready.If there is an error,      */
/*         allow a retry or an abort.                               */
/*                                                                  */
             CHKTAP     DEV(&TDEV)
/*                                                                  */
             MONMSG     MSGID(CPF0000 CPD0000 CPA0000 MCH0000) EXEC(DO)
/**********  CHGVAR VAR(&MSG8) VALUE(&MSG9****&TDEV****&MSG7)                         */ /*BG18886*/
             CHGVAR VAR(&MSG8) VALUE(&MSG9 *CAT &TDEV *TCAT &MSG7)                       /*BG18886*/
             SNDUSRMSG  MSG(&MSG8) VALUES('y' 'Y' 'n' 'N') +
                          MSGRPY(&REPLY)
               IF         COND((&REPLY *EQ 'y   ') *OR (&REPLY *EQ 'Y +
                            ')) THEN(GOTO CMDLBL(P9001A))
               IF         COND((&REPLY *EQ 'n   ') *OR (&REPLY *EQ 'N +
                            ')) THEN(GOTO CMDLBL(P9003))
             ENDDO
/*                                                                  */
/*    Allow promting of RSTOBJ command from device &TDEV(optional)  */
/*                                                                  */
/**********  RSTOBJ     ?*OBJ(EXCDBD EXCDF4A EXCDF4B EXCDF4C EXCDF4D + */                 /*207764*/
/**********               EXCDF4E EXCDF4F EXCDF4G EXCDF4H EXCDF4I +    */                 /*207764*/
/**********               EXCDF4J EXCDF4K EXCDF4L) ??SAVLIB(*N) +      */                 /*207764*/
/**********               ?*DEV(&TDEV)                                 */                 /*207764*/
             RSTOBJ     ?*OBJ(EXCDBD EXCDF4A EXCDF4B EXCDF4C EXCDF4D +
                          EXCDF4E EXCDF4F EXCDF4G EXCDF4H EXCDF4I +
                          EXCDF4J EXCDF4K EXCDF4L) ??SAVLIB(*N) +
                          ?*DEV(&TDEV) OUTPUT(*PRINT)                                     /*207764*/
/*                                                                  */
/*    If CMD1 is taken from RSTOBJ command program will abort.      */
/*                                                                  */
             MONMSG     MSGID(CPF6801) EXEC(GOTO CMDLBL(P9003))
/*                                                                  */
/*       If error on command allow user to either try again or      */
/*         abort.                                                   */
/*                                                                  */
             MONMSG     MSGID(CPF0000 MCH0000 CPA0000 CPD0000) EXEC(DO)
/**********  CHGVAR VAR(&MSG10) VALUE(&MSG11****&TDEV****&MSG7)                      */ /*BG18886*/
             CHGVAR VAR(&MSG10) VALUE(&MSG11 *CAT &TDEV *TCAT &MSG7)                    /*BG18886*/
             SNDUSRMSG  MSG(&MSG10) VALUES('y' 'Y' 'n' 'N') +
                          MSGRPY(&REPLY)
               IF         COND((&REPLY *EQ 'y') *OR (&REPLY *EQ 'Y')) +
                            THEN(GOTO CMDLBL(P9001))
               IF         COND((&REPLY *EQ 'n') *OR (&REPLY *EQ 'N')) +
                            THEN(GOTO CMDLBL(P9003))
             ENDDO
/*                                                                  */
/********************************************************************/
 
             GOTO       ENDPGM
 
 P9003:      DLTF       FILE(QTEMP/NEXTAPFL)
 
 P9002:      CLRPFM     FILE(NEXCDB)
 
             GOTO       END
 
 ENDPGM:     DLTF       FILE(QTEMP/NEXTAPFL)
             CLRPFM     FILE(NEXCDB)                                  /*E16834*/
 
/*END:********ENDPGM                                                  /*S01117*/
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM                                                   /*S01117*/
