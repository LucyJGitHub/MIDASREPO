/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas HF Display information online')                 */
/*********************************************************************/
/*                                                                   */
/*       Midas - History and Audit Facility Module           */
/*                                                                   */
/*       HFC0500  - DISPLAY INFORMATION ON LINE                      */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. 240378             Date 15Jun06              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      087527             Date 16Jun95              */
/*                      S01379             DATE 17SEP92              */
/*            AMEND NO.                    DATE                      */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       240378 - History Audit Facility failing with session or     */
/*                device error.  Fix is to ensure consistent record  */
/*                lenght of JRNDUMMY.  Applied fix 236026.           */
/*       087527 - MCH0601 space offset outside current limit for     */
/*                objects journal.                                   */
/*       S01379 - New program for HAF.                               */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
 
             PGM
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&JUSER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&NPEF) TYPE(*CHAR) LEN(10)
             DCL        VAR(&NUSER) TYPE(*CHAR) LEN(1)
             DCL        VAR(&DATE) TYPE(*CHAR) LEN(6)
             DCL        VAR(&JPGM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&NPGM ) TYPE(*CHAR) LEN(1)
             DCL        VAR(&JCOM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&NCOM ) TYPE(*CHAR) LEN(1)
             DCL        VAR(&OVR) TYPE(*CHAR) LEN(10)
             DCL        VAR(&OVR2) TYPE(*CHAR) LEN(10)
             DCL        VAR(&COU) TYPE(*DEC) LEN(2 0) VALUE(0)
             DCL        VAR(&ENTT) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RECF) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PAR) TYPE(*CHAR) LEN(50)
             DCL        VAR(&TEX) TYPE(*CHAR) LEN(100)
             DCL        VAR(&QRY) TYPE(*CHAR) LEN(256)
             DCL        VAR(&POS) TYPE(*CHAR) LEN(4)
             DCL        VAR(&PLEN) TYPE(*CHAR) LEN(4)
             DCL        VAR(&SRLN) TYPE(*CHAR) LEN(8)
             DCL        VAR(&TIME) TYPE(*CHAR) LEN(6)
             DCL        VAR(&STIM) TYPE(*CHAR) LEN(6)
             DCL        VAR(&HFLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&LID) TYPE(*CHAR) LEN(2)
 
/* */
/** GLOBAL MONITOR MESSAGE */
/* */
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/* */
/* Get library ID and build the HFLIB variable */
/* */
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&LID)
             CHGVAR     VAR(&HFLIB) VALUE(&LID *CAT 'HFLIB')
 
 
/* */
/* Ensure that QTEMP is at the bottom of the library list */
/* */
             RMVLIBLE   LIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             ADDLIBLE   LIB(QTEMP) POSITION(*LAST)
 
/* */
/* Create data areas in QTEMP needed by sub programs */
/* */
             CRTDTAARA  DTAARA(QTEMP/JRN) TYPE(*CHAR) LEN(256)
             MONMSG     MSGID(CPF0000)
 
             CRTDTAARA  DTAARA(QTEMP/JRN2) TYPE(*CHAR) LEN(256)
             MONMSG     MSGID(CPF0000)
 
             DLTDTAARA  DTAARA(QTEMP/JRNMOD)
             MONMSG     MSGID(CPF0000)
             CRTDTAARA  DTAARA(QTEMP/JRNMOD) TYPE(*CHAR) LEN(6) +
                          VALUE('IPCONL') TEXT('Mode of run')
 
/* */
/* Delete file QTEMP/HFSCANPD if it exists */
/* */
             DLTF       FILE(QTEMP/HFSCANPD)
             MONMSG     MSGID(CPF0000)
 
 
/* */
/* Recreate QTEMP/HFSCANPD */
/* */
             CPYF       FROMFILE(HFSCANPD) TOFILE(QTEMP/HFSCANPD) +
                          FROMMBR(*ALL) TOMBR(*FROMMBR) +
                          MBROPT(*REPLACE) CRTFILE(*YES)
             MONMSG     MSGID(CPF2817)
 
/* */
/* Close JOURNAL */
/* */
             CLOF       OPNID(JOURNAL)
             MONMSG     MSGID(CPF0000)
 
/* */
/*Override HFSCANPD to the version in QTEMP */
/* */
             OVRDBF     FILE(HFSCANPD) TOFILE(QTEMP/HFSCANPD)
 
/* */
/* Start of loop */
/* */
 
 RETRY:      CHGVAR     VAR(&COU) VALUE(0)
 
/* */
/* Create command string */
/* */
             CHGVAR     VAR(&QRY) VALUE('(')
             CHGJOB     SWS(00000000)
 
/* */
/*Override JRNFILE2 to HFFILEPD */
/* */
             OVRDBF     FILE(JRNFILE2) TOFILE(HFFILEPD)
 
/* */
/* Initialise variables */
/* */
             RTVJOBA    USER(&USER)
             CHGDTAARA  DTAARA(JRN) VALUE(' ')
 
/* */
/* Call HF0500 to give selection screen */
/* */
             CALL       PGM(HF0500) PARM(&USER)
 
/* */
/* Terminate on error */
/* */
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(END))
             IF         COND(%SWITCH(X000X00X)) THEN(GOTO CMDLBL(END))
 
/* */
/* Retrieve the details from HF0500 */
/* */
             RTVDTAARA  DTAARA(JRN (23 10)) RTNVAR(&OVR)
 
 
/* */
/* Process if both U2 and U6 from HF0500 are off */
/* */
             IF         COND(%SWITCH(X0XXX0XX)) THEN(DO)
 
/* */
/* Override JOURNAL to the file from HF0500 */
/* */
             OVRDBF     FILE(JOURNAL) TOFILE(&OVR) MBR(JRNFIL) +
                          SHARE(*YES)
 
/* */
/* Check the file exists, if not go back to try again */
/* */
             CHKOBJ     OBJ(&OVR) OBJTYPE(*FILE) MBR(JRNFIL)
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(RETRY))
 
/* */
/* If the file exists then check the F version of this file */
/* */
             CHGVAR     VAR(&OVR2) VALUE('F' *TCAT %SST(&OVR 2 9))
             CHKOBJ     OBJ(&HFLIB/&OVR2) OBJTYPE(*FILE) MBR(&USER)
 
/* */
/* If the file does not exist copy the standard member into the */
/* user member */
/* */
             MONMSG     MSGID(CPF0000) EXEC(DO)
             CPYF       FROMFILE(&HFLIB/&OVR2) TOFILE(&HFLIB/&OVR2) +
                          FROMMBR(&OVR2) TOMBR(&USER) MBROPT(*ADD)
             ENDDO
 
/* */
/* Override the file FIELDS to the F file, member &USER */
/* */
             OVRDBF     FILE(FIELDS) TOFILE(&OVR2) MBR(&USER)
 
/* */
/* If file does not exist then retry */
/* */
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(RETRY))
 
/* */
/* If U4 was on from HF0500 */
/* */
             IF         COND(%SWITCH(XXX1XXXX)) THEN(DO)
 
/* */
/* Override the file JOURNAL to member JRNHIST in the file from */
/* HF0500 */
/* */
             OVRDBF     FILE(JOURNAL) TOFILE(&HFLIB/&OVR) +
                          MBR(JRNHIST) SHARE(*YES)
 
/* */
/* Check file exists */
/* */
             CHKOBJ     OBJ(&HFLIB/&OVR) OBJTYPE(*FILE) MBR(JRNHIST)
 
/* */
/* If file does not exist then retry */
/* */
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(RETRY))
             ENDDO
 
/* */
/* If U7 was on from HF0500 */
/* */
             IF         COND(%SWITCH(XXXXXX1X)) THEN(DO)
 
/* */
/* Override the file JOURNAL to member JRNBATCH in the file from */
/* HF0500 */
/* */
             OVRDBF     FILE(JOURNAL) TOFILE(&HFLIB/&OVR) +
                          MBR(JRNBATCH) SHARE(*YES)
 
/* */
/* Check file exists */
/* */
             CHKOBJ     OBJ(&HFLIB/&OVR) OBJTYPE(*FILE) MBR(JRNBATCH)
 
/* */
/* If file does not exist then retry */
/* */
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(RETRY))
             ENDDO
             ENDDO
 
 
/* */
/* If U6 is on then need to process non-permanent physical file */
/* */
 RET2:       IF         COND(%SWITCH(XXXXX1XX)) THEN(DO)
 
/* */
/* Call HF0540 for print parameters */
/* */
             CALL       PGM(HF0520) PARM(&NPEF)
 
/* */
/* On error then exit program */
/* */
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(END))
             IF         COND(%SWITCH(1XXXXXXX)) THEN(GOTO CMDLBL(END))
 
/* */
/* Retry if the user does not wish to process further */
/* */
             IF         COND(%SWITCH(XXXX1XXX)) THEN(GOTO +
                          CMDLBL(RETRY))
 
/* */
/* Delete QTEMP/FIELDS if it exists to recreate it for the */
/* non-permanent file */
/* */
             DLTF       FILE(QTEMP/FIELDS)
             MONMSG     MSGID(CPF0000)
 
/* */
/* DSPFFD of file to give QTEMP/FIELDS */
/* */
             DSPFFD     FILE(&NPEF) OUTPUT(*OUTFILE) +
                          OUTFILE(QTEMP/FIELDS)
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(RET2))
 
/* */
/* Delete QTEMP/JOURNAL if it exists to recreate it for the */
/* non-permanent file */
/* */
             DLTF       FILE(QTEMP/JOURNAL)
             MONMSG     MSGID(CPF0000)
 
/* */
/* Overide file FIELDS to the QTEMP/FIELDS */
/* */
             OVRDBF     FILE(FIELDS) TOFILE(QTEMP/FIELDS)
 
/* */
/* Call HFC0510 to select entries and read journal */
/* */
             CALL       PGM(HFC0510) PARM(&OVR &NPEF)
 
/* */
/* On error then exit program */
/* */
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(END))
             IF         COND(%SWITCH(1XXXXXXX)) THEN(GOTO CMDLBL(END))
 
/* */
/* If user does not want to proceed further then go back to main */
/* enquiry */
/* */
             IF         COND(%SWITCH(XXXX1XXX)) THEN(GOTO +
                          CMDLBL(RETRY))
 
/* */
/* Delete QTEMP/JOURNAL and rename QTEMP/XX created in HFC0510 */
/* to file JOURNAL */
/* */
             DLTF       FILE(QTEMP/JOURNAL)
             MONMSG MSGID(CPF0000)
             RNMOBJ     OBJ(QTEMP/XX) OBJTYPE(*FILE) NEWOBJ(JOURNAL)
 
/* */
/* On error then restart */
/* */
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(RETRY))
 
/* */
/* Override JOURNAL to the new file in QTEMP */
/* */
             OVRDBF     FILE(JOURNAL) TOFILE(QTEMP/JOURNAL) SHARE(*YES)
             ENDDO
 
 
/* */
/* If U2 is on from HF0500 then today's entries requested */
/* */
             IF         COND(%SWITCH(X1XXXXXX)) THEN(DO)
 
/* */
/* Get the F version of the file */
/* */
             CHGVAR     VAR(&OVR2) VALUE('F' *TCAT %SST(&OVR 2 9))
 
/* */
/* Check the file exists */
/* */
             CHKOBJ     OBJ(&HFLIB/&OVR2) OBJTYPE(*FILE) MBR(&USER)
 
/* */
/* If the member does not exist then copy from the generic member */
/* to the user member */
/* */
             MONMSG     MSGID(CPF0000) EXEC(DO)
             CPYF       FROMFILE(&HFLIB/&OVR2) TOFILE(&HFLIB/&OVR2) +
                          FROMMBR(&OVR2) TOMBR(&USER) MBROPT(*ADD)
             ENDDO
 
/* */
/* Override the file FIELDS to the file from HF0500 */
/* */
             OVRDBF     FILE(FIELDS) TOFILE(&OVR2) MBR(&USER)
 
/* */
/* If the member does not exist then retry */
/* */
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(RETRY))
 
/* */
/* Call HFC0510 to select entries and read journal */
/* */
             CALL       PGM(HFC0510) PARM(&OVR &NPEF)
 
/* */
/* On error exit the program */
/* */
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(END))
             IF         COND(%SWITCH(1XXXXXXX)) THEN(GOTO CMDLBL(END))
             IF         COND(%SWITCH(XXXX1XXX)) THEN(GOTO +
                          CMDLBL(RETRY))
 
/* */
/* Delete QTEMP/JOURNAL and rename QTEMP/XX created in HFC0510 */
/* to file JOURNAL */
/* */
             DLTF       FILE(QTEMP/JOURNAL)
             MONMSG     MSGID(CPF0000)
             RNMOBJ     OBJ(QTEMP/XX) OBJTYPE(*FILE) NEWOBJ(JOURNAL)
 
/* */
/* Override JOURNAL to the new file in QTEMP */
/* */
             OVRDBF     FILE(JOURNAL) TOFILE(QTEMP/JOURNAL) SHARE(*YES)
             ENDDO
 
 
/* */
/* Initialise variables */
/* */
             RTVSYSVAL  SYSVAL(QTIME) RTNVAR(&TIME)
             CHGVAR     VAR(&STIM) VALUE(&TIME)
             RTVJOBA    DATE(&DATE)
 
/* */
/* Build the query command string */
/* User */
/* */
             RTVDTAARA  DTAARA(JRN (1 1)) RTNVAR(&NUSER)
             IF         COND(&NUSER *EQ 'Y') THEN(DO)
             IF         COND(&COU *NE 0) THEN(CHGVAR VAR(&QRY) +
                          VALUE(&QRY *BCAT '*AND '))
             RTVDTAARA  DTAARA(JRN (2 10)) RTNVAR(&JUSER)
             CHGVAR     VAR(&QRY) VALUE(&QRY *BCAT '(JOUSER *EQ "' +
                          *TCAT &JUSER *TCAT '")')
             CHGVAR     VAR(&COU) VALUE(1)
             ENDDO
 
/* */
/* Pgm */
/* */
             RTVDTAARA  DTAARA(JRN (12 1)) RTNVAR(&NPGM)
             IF         COND(&NPGM *EQ 'Y') THEN(DO)
             IF         COND(&COU *NE 0) THEN(CHGVAR VAR(&QRY) +
                          VALUE(&QRY *BCAT '*AND '))
             RTVDTAARA  DTAARA(JRN (13 10)) RTNVAR(&JPGM)
             CHGVAR     VAR(&QRY) VALUE(&QRY *BCAT '(JOPGM *EQ "' +
                          *TCAT &JPGM *TCAT '")')
             CHGVAR     VAR(&COU) VALUE(1)
             ENDDO
 
/* */
/* Comit cycle ID */
/* */
             RTVDTAARA  DTAARA(JRN (162 1)) RTNVAR(&NCOM)
             IF         COND(&NCOM *EQ 'Y') THEN(DO)
             IF         COND(&COU *NE 0) THEN(CHGVAR VAR(&QRY) +
                          VALUE(&QRY *BCAT '*AND '))
             RTVDTAARA  DTAARA(JRN (163 10)) RTNVAR(&JCOM)
             CHGVAR     VAR(&QRY) VALUE(&QRY *BCAT '(JOCCID *EQ ' +
                          *BCAT &JCOM *TCAT ')')
             CHGVAR     VAR(&COU) VALUE(1)
             ENDDO
 
 
/* */
/* Entry types */
/* */
             RTVDTAARA  DTAARA(JRN (33 1)) RTNVAR(&ENTT)
             IF         COND(&ENTT *EQ 'I') THEN(DO)
             IF         COND(&COU *NE 0) THEN(CHGVAR VAR(&QRY) +
                          VALUE(&QRY *BCAT '*AND '))
             CHGVAR     VAR(&QRY) VALUE(&QRY *BCAT '((JOENTT *EQ +
                          "PT") *OR (JOENTT *EQ "DL"))')
             CHGVAR     VAR(&COU) VALUE(1)
             ENDDO
 
/* */
/* Journal codes */
/* */
             IF         COND(&ENTT *EQ 'C') THEN(DO)
             IF         COND(&COU *NE 0) THEN(CHGVAR VAR(&QRY) +
                          VALUE(&QRY *BCAT '*AND '))
             CHGVAR     VAR(&QRY) VALUE(&QRY *BCAT '((JOENTT *EQ +
                          "UB") *OR (JOENTT *EQ "UP"))')
             CHGVAR     VAR(&COU) VALUE(1)
             ENDDO
             IF         COND(&ENTT *EQ 'R') THEN(DO)
             IF         COND(&COU *NE 0) THEN(CHGVAR VAR(&QRY) +
                          VALUE(&QRY *BCAT '*AND '))
             CHGVAR     VAR(&QRY) VALUE(&QRY *BCAT '((JOENTT *EQ +
                          "DR") *OR (JOENTT *EQ "BR") *OR (JOENTT +
                          *EQ "UR"))')
             CHGVAR     VAR(&COU) VALUE(1)
             ENDDO
 
/* */
/* Record formats to be omitted */
/* */
             RTVDTAARA  DTAARA(JRN (42 10)) RTNVAR(&RECF)
             IF         COND(&RECF *NE '          ') THEN(DO)
             IF         COND(&COU *NE 0) THEN(CHGVAR VAR(&QRY) +
                          VALUE(&QRY *BCAT '*AND '))
             CHGVAR     VAR(&QRY) VALUE(&QRY *BCAT '(JOOBJ *NE "' +
                          *TCAT &RECF *TCAT '")')
             CHGVAR     VAR(&COU) VALUE(1)
             ENDDO
             RTVDTAARA  DTAARA(JRN (52 10)) RTNVAR(&RECF)
             IF         COND(&RECF *NE '          ') THEN(DO)
             IF         COND(&COU *NE 0) THEN(CHGVAR VAR(&QRY) +
                          VALUE(&QRY *BCAT '*AND '))
             CHGVAR     VAR(&QRY) VALUE(&QRY *BCAT '(JOOBJ *NE "' +
                          *TCAT &RECF *TCAT '")')
             CHGVAR     VAR(&COU) VALUE(1)
             ENDDO
             RTVDTAARA  DTAARA(JRN (62 10)) RTNVAR(&RECF)
             IF         COND(&RECF *NE '          ') THEN(DO)
             IF         COND(&COU *NE 0) THEN(CHGVAR VAR(&QRY) +
                          VALUE(&QRY *BCAT '*AND '))
             CHGVAR     VAR(&QRY) VALUE(&QRY *BCAT '(JOOBJ *NE "' +
                          *TCAT &RECF *TCAT '")')
             CHGVAR     VAR(&COU) VALUE(1)
             ENDDO
             RTVDTAARA  DTAARA(JRN (72 10)) RTNVAR(&RECF)
             IF         COND(&RECF *NE '          ') THEN(DO)
             IF         COND(&COU *NE 0) THEN(CHGVAR VAR(&QRY) +
                          VALUE(&QRY *BCAT '*AND '))
             CHGVAR     VAR(&QRY) VALUE(&QRY *BCAT '(JOOBJ *NE "' +
                          *TCAT &RECF *TCAT '")')
             CHGVAR     VAR(&COU) VALUE(1)
             ENDDO
             RTVDTAARA  DTAARA(JRN (82 10)) RTNVAR(&RECF)
             IF         COND(&RECF *NE '          ') THEN(DO)
             IF         COND(&COU *NE 0) THEN(CHGVAR VAR(&QRY) +
                          VALUE(&QRY *BCAT '*AND '))
             CHGVAR     VAR(&QRY) VALUE(&QRY *BCAT '(JOOBJ *NE "' +
                          *TCAT &RECF *TCAT '")')
             CHGVAR     VAR(&COU) VALUE(1)
             ENDDO
 
/* */
/*  Select Key to different Journal files */
/* */
             RTVDTAARA  DTAARA(JRN (102 50)) RTNVAR(&PAR)
             RTVDTAARA  DTAARA(JRN (34 4)) RTNVAR(&POS)
             RTVDTAARA  DTAARA(JRN (38 4)) RTNVAR(&PLEN)
             IF         COND(&PAR *NE ' ') THEN(DO)
             IF         COND(&COU *NE 0) THEN(CHGVAR VAR(&QRY) +
                          VALUE(&QRY *BCAT '*AND '))
             CHGVAR     VAR(&TEX) VALUE('(%SST(JOESD ' *BCAT &POS +
                          *BCAT ' ' *BCAT &PLEN *BCAT ') *EQ "' +
                          *CAT %SST(&PAR 1 50) *TCAT '")')
             CHGVAR     VAR(&QRY) VALUE(&QRY *BCAT &TEX)
             CHGVAR     VAR(&COU) VALUE(1)
             ENDDO
 
             IF         COND(&COU *NE 0) THEN(DO)
             CHGVAR     VAR(&QRY) VALUE(&QRY *TCAT ')')
 
/* */
/* Use OPNQRYF to select over file JOURNAL */
/* */
/*********** OPNQRYF    FILE((JOURNAL)) OPTION(*ALL) QRYSLT(&QRY) +    *087527*/
/***********              KEYFLD(*FILE) OPTIMIZE(*MINWAIT) SEQONLY(*NO)*087527*/
             OPNQRYF    FILE((JOURNAL)) OPTION(*ALL) +
                        FORMAT(HFJRNLPD) QRYSLT(&QRY) +
                        KEYFLD(*FILE) SEQONLY(*NO) OPTIMIZE(*MINWAIT) /*087527*/
                          ENDDO
             RTVSYSVAL  SYSVAL(QSRLNBR) RTNVAR(&SRLN)
             CHGJOB     SWS(XXXX0XXX)
 
/* */
/* Ensure that member JRNDUMMY exists in file QTEMP/JRNDUMMY */
/* */
             DLTF       FILE(QTEMP/JRNDUMMY)
             MONMSG     MSGID(CPF0000)
/**********  CRTSRCPF   FILE(QTEMP/JRNDUMMY) TEXT('Dummy source +  */                     /*240378*/
/**********               file. Do not move into another lib')     */                     /*240378*/
             CRTSRCPF   FILE(QTEMP/JRNDUMMY) RCDLEN(112) TEXT('Dummy +
                          source file. Do not move into another lib')                     /*240378*/
             MONMSG     MSGID(CPF0000)
             ADDPFM     FILE(QTEMP/JRNDUMMY) MBR(JRNDUMMY)
             MONMSG     MSGID(CPF0000)
 
/* */
/* Call Print control program HF0530 */
/* */
             DLTF       FILE(QTEMP/HFSCANL0)
             MONMSG     MSGID(CPF0000)
             DLTF       FILE(QTEMP/HFSCANL1)
             MONMSG     MSGID(CPF0000)
             CALL       PGM(HF0530) PARM(&SRLN &DATE)
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(END))
/* */
/* Close file JOURNAL */
/* */
             CLOF       OPNID(JOURNAL)
             MONMSG     MSGID(CPF0000)
 
/* */
/* If user has more requests then go back to retry */
/* */
             IF         COND(%SWITCH(XXXX1XXX)) THEN(GOTO +
                          CMDLBL(RETRY))
 
             GOTO       CMDLBL(END)
/* */
/** ABNORMAL ERROR PROCESSING                                      */
/* */
 ABNOR:      SNDPGMMSG  MSG('PROGRAM HFC0500 ENDED ABNORMALLY') +
                          TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
/* */
/* Exit point for program */
/* */
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
