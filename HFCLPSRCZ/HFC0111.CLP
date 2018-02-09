/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas HF Journal file J...... file')                  */
/*********************************************************************/
/*                                                                   */
/*       Midas     - History and Audit Facility Module           */
/*                                                                   */
/*       HFC0111  - CREATE EXTRACT FILES                             */
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
/*       PREV AMEND NO. 099185             DATE 10JUL96              */
/*                      S01379             DATE 15SEP92              */
/*                                         DATE                      */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*      MD046248 - Finastra Rebranding                               */
/*      099185  - HAF uses date format DDMMYY, so change job to use  */
/*                date format *DMY, and reset it afterwards.         */
/*       S01379 - New program for HAF.                               */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
 
             PGM        PARM(&UACT &ULEN &ULFN &UOK &PY1 &PY2 &PY3 +
                          &PY4 &PY5 &PY6 &TEXT)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&UACT) TYPE(*CHAR) LEN(1)
             DCL        VAR(&ULEN) TYPE(*DEC) LEN(5)
             DCL        VAR(&ULFN) TYPE(*CHAR) LEN(10)
             DCL        VAR(&FLFN) TYPE(*CHAR) LEN(10)
             DCL        VAR(&UOK) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PY1) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PY2) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PY3) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PY4) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PY5) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PY6) TYPE(*CHAR) LEN(10)
             DCL        VAR(&TEXT) TYPE(*CHAR) LEN(25)
             DCL        VAR(&TEXT2) TYPE(*CHAR) LEN(45)
             DCL        VAR(&SAV) TYPE(*CHAR) LEN(1)
             DCL        VAR(&HFLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&LID) TYPE(*CHAR) LEN(2)
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(60) VALUE('Journal +
                          file check in progress - Please wait')
             DCL        VAR(&MSGID) TYPE(*CHAR) LEN(7)
             DCL        VAR(&MSSV) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MSPG) TYPE(*CHAR) LEN(10) VALUE('HFC0111')
             DCL        VAR(&MSFM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MSRP) TYPE(*CHAR) LEN(1)
             DCL        VAR(&QDATFMT) TYPE(*CHAR) LEN(4)           /*099185*/
 
 
/* */
/* Global MONMSG */
/* */
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ERROR))
 
/* Change Date Format to be DDMMYY, which is the format used by HAF.   099185*/
             RTVJOBA    DATFMT(&QDATFMT)                             /*099185*/
             CHGJOB     LOG(4 00 *MSG) LOGCLPGM(*YES) DATFMT(*DMY) +
/************CHGJOB*****LOG(4 00 *MSG)*LOGCLPGM(*YES)******************099185*/
/* */
/*  Set up the text */
/* */
             CHGVAR     VAR(&TEXT2) VALUE('Midas HF' *BCAT +
                          &TEXT)
 
/* */
/* Set default return code to OK */
/* */
             CHGVAR     VAR(&UOK) VALUE('Y')
 
/* */
/* Get library ID and build the HFLIB variable */
/* */
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&LID)
             CHGVAR     VAR(&HFLIB) VALUE(&LID *CAT 'HFLIB')
 
/* */
/* If action code not insert then go to the amend section */
/* */
             IF         COND(&UACT *NE 'I') THEN(DO)
             GOTO       CMDLBL(AMEPGM)
             ENDDO
 
/* --------------------ACTION INPUT---------------------------------*/
 
 
/* */
/* Build extract file */
/* */
             DSPJRN     JRN(*LIBL/ICJRN) NBRENT(1) ENTDTALEN(&ULEN) +
                          OUTPUT(*OUTFILE) OUTFILE(&HFLIB/&ULFN)
             RMVM       FILE(&HFLIB/&ULFN) MBR(*ALL)
             MONMSG     MSGID(CPF0000)
             CHGPF      FILE(&HFLIB/&ULFN) MAXMBRS(*NOMAX) +
                          SIZE(*NOMAX) TEXT(&TEXT2)
/* */
/* Member JRNFIL */
/* */
             ADDPFM     FILE(&HFLIB/&ULFN) MBR(JRNFIL)
 
 
/* */
/* Member JRNBATCH */
/* */
             ADDPFM     FILE(&HFLIB/&ULFN) MBR(JRNBATCH)
 
 
/* */
/* Member JRNTEMP  */
/* */
             ADDPFM     FILE(&HFLIB/&ULFN) MBR(JRNTEMP)
 
 
/* */
/* Member JRNHIST  */
/* */
             ADDPFM     FILE(&HFLIB/&ULFN) MBR(JRNHIST)
 
/* */
/* Grant authority to the file for other users */
/* */
             GRTOBJAUT  OBJ(&HFLIB/&ULFN) OBJTYPE(*FILE) +
                          USER(*PUBLIC) AUT(*ALL)
             MONMSG     MSGID(CPF0000)
 
/* */
/* End of action Insert */
/* */
             GOTO       CMDLBL(ENDPGM)
 
AMEPGM:
/* --------------------ACTION AMEND---------------------------------*/
 
/* */
/* Set variable for recovery */
/* */
             CHGVAR     VAR(&SAV) VALUE('N')
 
/* */
/* SAVE OLD FILES */
/* */
 
/* */
/* Save data from old files */
/* */
             DLTF       FILE(QTEMP/FIL1)
             MONMSG     MSGID(CPF0000)
 
 
/* */
/* Save data from member JRNFIL */
/* */
             CPYF       FROMFILE(&HFLIB/&ULFN) TOFILE(QTEMP/FIL1) +
                          FROMMBR(JRNFIL) TOMBR(*FROMMBR) +
                          MBROPT(*ADD) CRTFILE(*YES) FMTOPT(*NOCHK)
             MONMSG     MSGID(CPF2817)
 
/* */
/* Send message so user knows it hasn't stopped */
/* */
             CHGVAR     VAR(&MSGID) VALUE('HFM0008')
             CHGVAR     VAR(&MSSV) VALUE(*BLANKS)
/* */
             CALL       PGM(HFC0012) PARM(&MSGID &MSSV)
/* */
             CHGVAR     VAR(&MSPG) VALUE('HFC0111')
             CHGVAR     VAR(&MSFM) VALUE('MIDASMSG')
             CHGVAR     VAR(&MSRP) VALUE(*BLANKS)
/* */
             CALL       PGM(HFC0010) PARM(&MSPG &MSFM &MSRP)
 
/* */
/* Change size and max no of members if file created here */
/* */
             CHGPF      FILE(QTEMP/FIL1) MAXMBRS(*NOMAX) +
                          SIZE(*NOMAX)
             MONMSG     MSGID(CPF0000)
 
/*********************************************************************/
 
/* */
/* Save data from member JRNBATCH */
/* */
             CPYF       FROMFILE(&HFLIB/&ULFN) TOFILE(QTEMP/FIL1) +
                          FROMMBR(JRNBATCH) TOMBR(*FROMMBR) +
                          MBROPT(*ADD) CRTFILE(*YES) FMTOPT(*NOCHK)
             MONMSG     MSGID(CPF2817)
 
/* */
/* Send message so user knows it hasn't stopped */
/* */
             CHGVAR     VAR(&MSGID) VALUE('HFM0008')
             CHGVAR     VAR(&MSSV) VALUE(*BLANKS)
/* */
             CALL       PGM(HFC0012) PARM(&MSGID &MSSV)
/* */
             CHGVAR     VAR(&MSPG) VALUE('HFC0111')
             CHGVAR     VAR(&MSFM) VALUE('MIDASMSG')
             CHGVAR     VAR(&MSRP) VALUE(*BLANKS)
/* */
             CALL       PGM(HFC0010) PARM(&MSPG &MSFM &MSRP)
 
/* */
/* Change size and max no of members if file created here */
/* */
             CHGPF      FILE(QTEMP/FIL1) MAXMBRS(*NOMAX) +
                          SIZE(*NOMAX)
             MONMSG     MSGID(CPF0000)
 
 
/* */
/* Save data from member JRNTEMP */
/* */
             CPYF       FROMFILE(&HFLIB/&ULFN) TOFILE(QTEMP/FIL1) +
                          FROMMBR(JRNTEMP) TOMBR(*FROMMBR) +
                          MBROPT(*ADD) CRTFILE(*YES) FMTOPT(*NOCHK)
             MONMSG     MSGID(CPF2817)
 
/* */
/* Send message so user knows it hasn't stopped */
/* */
             CHGVAR     VAR(&MSGID) VALUE('HFM0008')
             CHGVAR     VAR(&MSSV) VALUE(*BLANKS)
/* */
             CALL       PGM(HFC0012) PARM(&MSGID &MSSV)
/* */
             CHGVAR     VAR(&MSPG) VALUE('HFC0111')
             CHGVAR     VAR(&MSFM) VALUE('MIDASMSG')
             CHGVAR     VAR(&MSRP) VALUE(*BLANKS)
/* */
             CALL       PGM(HFC0010) PARM(&MSPG &MSFM &MSRP)
 
/* */
/* Change size and max no of members if file created here */
/* */
             CHGPF      FILE(QTEMP/FIL1) MAXMBRS(*NOMAX) +
                          SIZE(*NOMAX)
             MONMSG     MSGID(CPF0000)
 
/*********************************************************************/
 
/* */
/* Save data from member JRNHIST */
/* */
             CPYF       FROMFILE(&HFLIB/&ULFN) TOFILE(QTEMP/FIL1) +
                          FROMMBR(JRNHIST) TOMBR(*FROMMBR) +
                          MBROPT(*ADD) CRTFILE(*YES) FMTOPT(*NOCHK)
 
/* */
/* If the JRNHIST member is empty then use the data from member */
/* JRNFIL */
/* */
             MONMSG     MSGID(CPF2817) EXEC(DO)
               CPYF       FROMFILE(&HFLIB/&ULFN) TOFILE(QTEMP/FIL1) +
                          FROMMBR(JRNFIL) TOMBR(JRNHIST) +
                          MBROPT(*ADD) CRTFILE(*YES) FMTOPT(*NOCHK)
             MONMSG     MSGID(CPF2817)
             ENDDO
 
/* */
/* Send message so user knows it hasn't stopped */
/* */
             CHGVAR     VAR(&MSGID) VALUE('HFM0008')
             CHGVAR     VAR(&MSSV) VALUE(*BLANKS)
/* */
             CALL       PGM(HFC0012) PARM(&MSGID &MSSV)
/* */
             CHGVAR     VAR(&MSPG) VALUE('HFC0111')
             CHGVAR     VAR(&MSFM) VALUE('MIDASMSG')
             CHGVAR     VAR(&MSRP) VALUE(*BLANKS)
/* */
             CALL       PGM(HFC0010) PARM(&MSPG &MSFM &MSRP)
 
/* */
/* Change size and max no of members if file created here */
/* */
             CHGPF      FILE(QTEMP/FIL1) MAXMBRS(*NOMAX) +
                          SIZE(*NOMAX)
             MONMSG     MSGID(CPF0000)
 
/* */
/* Set the recovery variable */
/* */
             CHGVAR     VAR(&SAV) VALUE('Y')
 
/* */
/* Ensure that the extract file does not exist in the library QTEMP */
/* */
             DLTF       FILE(QTEMP/&ULFN)
             MONMSG     MSGID(CPF0000)
 
/* */
/* Build a new extract file */
/* */
             DSPJRN     JRN(*LIBL/ICJRN) NBRENT(1) ENTDTALEN(&ULEN) +
                          OUTPUT(*OUTFILE) OUTFILE(QTEMP/&ULFN)
 
 
/* */
/* Remove the default member and add the new members */
/* */
 
             RMVM       FILE(QTEMP/&ULFN) MBR(*ALL)
             MONMSG     MSGID(CPF0000)
             CHGPF      FILE(QTEMP/&ULFN) MAXMBRS(*NOMAX) +
                          SIZE(*NOMAX) TEXT(&TEXT2)
             ADDPFM     FILE(QTEMP/&ULFN) MBR(JRNFIL)
             ADDPFM     FILE(QTEMP/&ULFN) MBR(JRNBATCH)
             ADDPFM     FILE(QTEMP/&ULFN) MBR(JRNTEMP)
             ADDPFM     FILE(QTEMP/&ULFN) MBR(JRNHIST)
 
 
/* */
/* Now restore the file to the library xxHFLIB */
/* */
             DLTF       FILE(&HFLIB/&ULFN)
             MONMSG     MSGID(CPF0000)
 
             CRTDUPOBJ  OBJ(&ULFN) FROMLIB(QTEMP) OBJTYPE(*FILE) +
                          TOLIB(&HFLIB) DATA(*NO)
 
 
/* */
/* Restore old records which meet the selection criteria */
/* Member JRNFIL first */
/* */
             CPYF       FROMFILE(QTEMP/FIL1) TOFILE(&HFLIB/&ULFN) +
                          FROMMBR(JRNFIL) TOMBR(*FROMMBR) +
                          MBROPT(*REPLACE) INCREL((*IF JOOBJ *EQ +
                          &PY1) (*OR JOOBJ *EQ &PY2) (*OR JOOBJ *EQ +
                          &PY3) (*OR JOOBJ *EQ &PY4) (*OR JOOBJ *EQ +
                          &PY5) (*OR JOOBJ *EQ &PY6)) FMTOPT(*NOCHK)
             MONMSG     MSGID(CPF2817)
 
/* */
/* Send message so user knows it hasn't stopped */
/* */
             CHGVAR     VAR(&MSGID) VALUE('HFM0008')
             CHGVAR     VAR(&MSSV) VALUE(*BLANKS)
/* */
             CALL       PGM(HFC0012) PARM(&MSGID &MSSV)
/* */
             CHGVAR     VAR(&MSPG) VALUE('HFC0111')
             CHGVAR     VAR(&MSFM) VALUE('MIDASMSG')
             CHGVAR     VAR(&MSRP) VALUE(*BLANKS)
/* */
             CALL       PGM(HFC0010) PARM(&MSPG &MSFM &MSRP)
 
 
/* */
/* Restore old records which meet the selection criteria */
/* Member JRNBATCH */
/* */
             CPYF       FROMFILE(QTEMP/FIL1) TOFILE(&HFLIB/&ULFN) +
                          FROMMBR(JRNBATCH) TOMBR(*FROMMBR) +
                          MBROPT(*REPLACE) INCREL((*IF JOOBJ *EQ +
                          &PY1) (*OR JOOBJ *EQ &PY2) (*OR JOOBJ *EQ +
                          &PY3) (*OR JOOBJ *EQ &PY4) (*OR JOOBJ *EQ +
                          &PY5) (*OR JOOBJ *EQ &PY6)) FMTOPT(*NOCHK)
             MONMSG     MSGID(CPF2817)
 
/* */
/* Send message so user knows it hasn't stopped */
/* */
             CHGVAR     VAR(&MSGID) VALUE('HFM0008')
             CHGVAR     VAR(&MSSV) VALUE(*BLANKS)
/* */
             CALL       PGM(HFC0012) PARM(&MSGID &MSSV)
/* */
             CHGVAR     VAR(&MSPG) VALUE('HFC0111')
             CHGVAR     VAR(&MSFM) VALUE('MIDASMSG')
             CHGVAR     VAR(&MSRP) VALUE(*BLANKS)
/* */
             CALL       PGM(HFC0010) PARM(&MSPG &MSFM &MSRP)
 
 
/* */
/* Restore old records which meet the selection criteria */
/* Member JRNTEMP */
/* */
             CPYF       FROMFILE(QTEMP/FIL1) TOFILE(&HFLIB/&ULFN) +
                          FROMMBR(JRNTEMP) TOMBR(*FROMMBR) +
                          MBROPT(*REPLACE) CRTFILE(*YES) +
                          INCREL((*IF JOOBJ *EQ &PY1) (*OR JOOBJ +
                          *EQ &PY2) (*OR JOOBJ *EQ &PY3) (*OR JOOBJ +
                          *EQ &PY4) (*OR JOOBJ *EQ &PY5) (*OR JOOBJ +
                          *EQ &PY6)) FMTOPT(*NOCHK)
             MONMSG     MSGID(CPF2817)
 
/* */
/* Send message so user knows it hasn't stopped */
/* */
             CHGVAR     VAR(&MSGID) VALUE('HFM0008')
             CHGVAR     VAR(&MSSV) VALUE(*BLANKS)
/* */
             CALL       PGM(HFC0012) PARM(&MSGID &MSSV)
/* */
             CHGVAR     VAR(&MSPG) VALUE('HFC0111')
             CHGVAR     VAR(&MSFM) VALUE('MIDASMSG')
             CHGVAR     VAR(&MSRP) VALUE(*BLANKS)
/* */
             CALL       PGM(HFC0010) PARM(&MSPG &MSFM &MSRP)
 
 
/* */
/* Restore old records which meet the selection criteria */
/* Member JRNHIST */
/* */
             CPYF       FROMFILE(QTEMP/FIL1) TOFILE(&HFLIB/&ULFN) +
                          FROMMBR(JRNHIST) TOMBR(*FROMMBR) +
                          MBROPT(*REPLACE) INCREL((*IF JOOBJ *EQ +
                          &PY1) (*OR JOOBJ *EQ &PY2) (*OR JOOBJ *EQ +
                          &PY3) (*OR JOOBJ *EQ &PY4) (*OR JOOBJ *EQ +
                          &PY5) (*OR JOOBJ *EQ &PY6)) FMTOPT(*NOCHK)
             MONMSG     MSGID(CPF2817)
 
/* */
/* Send message so user knows it hasn't stopped */
/* */
             CHGVAR     VAR(&MSGID) VALUE('HFM0008')
             CHGVAR     VAR(&MSSV) VALUE(*BLANKS)
/* */
             CALL       PGM(HFC0012) PARM(&MSGID &MSSV)
/* */
             CHGVAR     VAR(&MSPG) VALUE('HFC0111')
             CHGVAR     VAR(&MSFM) VALUE('MIDASMSG')
             CHGVAR     VAR(&MSRP) VALUE(*BLANKS)
/* */
             CALL       PGM(HFC0010) PARM(&MSPG &MSFM &MSRP)
 
 
/* */
/* Allow other users to access the file */
/* */
             GRTOBJAUT  OBJ(&HFLIB/&ULFN) OBJTYPE(*FILE) +
                          USER(*PUBLIC) AUT(*ALL)
 
             GOTO       CMDLBL(ENDPGM)
 
/* */
/* Global error routine */
/* */
 
ERROR:
 
/* */
/* Set return code to not OK */
/* */
             CHGVAR     VAR(&UOK) VALUE('N')
             MONMSG     MSGID(CPF0000)
 
/* */
/* If the files were not saved then exit the program */
/* */
             IF         COND(&SAV *EQ 'N') THEN(DO)
             GOTO       CMDLBL(ENDPGM)
             ENDDO
 
/* */
/* If the files were saved then restore them from QTEMP */
/* Ensure destination file does not exist first */
/* */
             DLTF       FILE(&HFLIB/ULFN)
             MONMSG     MSGID(CPF0000)
 
             CRTDUPOBJ  OBJ(FIL1) FROMLIB(QTEMP) OBJTYPE(*FILE) +
                          TOLIB(&HFLIB) NEWOBJ(&ULFN) DATA(*YES)
             MONMSG     MSGID(CPF0000)
 
 
/* */
/* COPY OLF F... BACK  */
/* */
             CHGVAR     VAR(&FLFN) VALUE('F' *CAT %SST(&ULFN 2 9))
             DLTF       FILE(&HFLIB/&FLFN)
             MONMSG     MSGID(CPF0000)
             MOVOBJ     OBJ(QTEMP/&FLFN) OBJTYPE(*FILE) TOLIB(&HFLIB)
             MONMSG     MSGID(CPF0000)
 
ENDPGM:      CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
/*RESET DATE FORMAT                                                     099185*/
             CHGJOB      DATFMT(&QDATFMT)                             /*099185*/
             ENDPGM
