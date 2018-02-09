/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas UP Move objects and source')                    */
/*********************************************************************/
/*                                                                   */
/*       Midas - Upgrade Module                                      */
/*                                                                   */
/*       UPC0350 - Move objects and source live                      */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. CUP002             Date 01Jun99              */
/*                      CUP001 *C *CREATE  Date 13Aug98              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CUP002 - Correction of message monitoring                   */
/*       CUP001 - Introduction of BRIDGE                             */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&AUMBNM &OBJTYPE &AUSRCF &NEWOBJLIB +
                          &NEWSRCLIB &OLDOBJLIB &OLDSRCLIB &OWNER +
                          &AUTL &RETURN)
 
             DCL        VAR(&AUMBNM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&OBJTYPE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&AUSRCF) TYPE(*CHAR) LEN(10)
             DCL        VAR(&NEWOBJLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&NEWSRCLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&OLDOBJLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&OLDSRCLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&OWNER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&AUTL) TYPE(*CHAR) LEN(10)
             DCL        VAR(&RETURN) TYPE(*CHAR) LEN(1)
 
             DCL        VAR(&MOVLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&SAVENAME) TYPE(*CHAR) LEN(10) VALUE(' ')
             DCL        VAR(&CHGLIB) TYPE(*CHAR) LEN(1) VALUE('N')
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
/* Global monitor message */
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CHGJOB     LOG(4 0 *SECLVL) LOGCLPGM(*YES)
             CHGJOB     SWS(XXXXXX00)
 
             CHGVAR     VAR(&MOVLIB) VALUE('#.' *TCAT &OLDOBJLIB)
 
             IF         COND(&OBJTYPE *NE '/COPY' *AND &OBJTYPE *NE +
                          'DATA') THEN(DO)
                CHKOBJ     OBJ(&NEWOBJLIB/&AUMBNM) OBJTYPE(&OBJTYPE)
                MONMSG     MSGID(CPF9801) EXEC(DO)
                   GOTO       CMDLBL(END)
                ENDDO
/* Move object from live library to '#.' version of library */
                MOVOBJ     OBJ(&OLDOBJLIB/&AUMBNM) OBJTYPE(&OBJTYPE) +
                          TOLIB(&MOVLIB)
/* If object doesn't exist in from library then continue */
                MONMSG     MSGID(CPF2105)
/* If object already exists then try to rename it and move again */
                MONMSG     MSGID(CPF3201) EXEC(DO)
                   RNMOBJ     OBJ(&MOVLIB/&AUMBNM) OBJTYPE(&OBJTYPE) +
                          NEWOBJ('#.' *TCAT &AUMBNM)
/* If renamed object already exists then flag as failure */
                   MONMSG     MSGID(CPF3201) EXEC(DO)
                      GOTO       CMDLBL(ABNOR)
                   ENDDO
                   MOVOBJ OBJ(&OLDOBJLIB/&AUMBNM) OBJTYPE(&OBJTYPE) +
                          TOLIB(&MOVLIB)
                ENDDO
/* Move object from installation library to live library */
                MOVOBJ     OBJ(&NEWOBJLIB/&AUMBNM) OBJTYPE(&OBJTYPE)    +
                          TOLIB(&OLDOBJLIB)
 
/* Change ownership and authorities */
                IF         COND(&OWNER *NE ' ') THEN(DO)
                  CHGOBJOWN OBJ(&OLDOBJLIB/&AUMBNM) OBJTYPE(&OBJTYPE) +
                          NEWOWN(&OWNER)
                ENDDO
                IF         COND(&AUTL *NE ' ') THEN(DO)
                  GRTOBJAUT OBJ(&OLDOBJLIB/&AUMBNM) OBJTYPE(&OBJTYPE) +
                          AUTL(&AUTL)
                ENDDO
             ENDDO
/* Check if source file member exists */
             IF         COND(&OBJTYPE *EQ '/COPY') THEN(DO)
                CHGVAR     VAR(&SAVENAME) VALUE(&OLDSRCLIB)
                CHGVAR     VAR(&OLDSRCLIB) VALUE(&OLDOBJLIB)
                CHGVAR     VAR(&CHGLIB) VALUE('Y')
             ENDDO
 
             IF         COND(&OLDSRCLIB *NE ' ') THEN(DO)
                CHKOBJ OBJ(&NEWSRCLIB/&AUSRCF) OBJTYPE(*FILE) +
                       MBR(&AUMBNM)
                MONMSG     MSGID(CPF9815 CPF9801) EXEC(DO)
                   IF         COND(&CHGLIB *EQ 'Y') THEN(DO)          /*CUP002*/
                      CHGVAR     VAR(&OLDSRCLIB) VALUE(&SAVENAME)     /*CUP002*/
                   ENDDO                                              /*CUP002*/
                   GOTO       CMDLBL(END)
                ENDDO
/* Copy existing version to the '#.' library */
                CPYF       FROMFILE(&OLDSRCLIB/&AUSRCF) +
                          TOFILE(&MOVLIB/&AUSRCF) +
                          FROMMBR(&AUMBNM) TOMBR(*FROMMBR) +
                          MBROPT(*REPLACE) CRTFILE(*YES)
                MONMSG     MSGID(CPF2817)
/* Copy new version of source to 'core' library */
                CPYF       FROMFILE(&NEWSRCLIB/&AUSRCF) +
                          TOFILE(&OLDSRCLIB/&AUSRCF) +
                          FROMMBR(&AUMBNM) TOMBR(*FROMMBR) +
                          MBROPT(*REPLACE) CRTFILE(*YES)
                MONMSG     MSGID(CPF2817)
             ENDDO
 
             IF         COND(&CHGLIB *EQ 'Y') THEN(DO)
                CHGVAR     VAR(&OLDSRCLIB) VALUE(&SAVENAME)
             ENDDO
 
             GOTO       CMDLBL(END)
 ABNOR:
             CHGVAR     VAR(&RETURN) VALUE('F')
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
