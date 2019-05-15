/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas HF Copy COB journal to dbase')                  */
/*********************************************************************/
/*                                                                   */
/*       Midas     - History and Audit Facility Module           */
/*                                                                   */
/*       HFC0220  - COPY COB EXTRACT TO THE DATABASE                 */
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
/*       Prev Amend No. 102670             Date 26Apr96              */
/*                      S01379             Date 15Sep92              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       102670 - Avoid abnormal termination if no files selected    */
/*                for HAF monitoring.                                */
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
             DCL        VAR(&COUN) TYPE(*DEC) LEN(1 0) VALUE(0)
             DCL        VAR(&Z) TYPE(*CHAR) LEN(5000)
             DCL        VAR(&TT) TYPE(*DEC) LEN(1 0) VALUE(0)
             DCL        VAR(&OFFILE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&HFLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&LID) TYPE(*CHAR) LEN(2)
 
             DCLF       FILE(HFFILEPD)
 
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
/* Create the CPYF variable */
/* */
             CHGVAR     VAR(&Z) VALUE('(')
 
 
/* */
/* Clear the JRNTEMP members in all the 'J' files - call HFC0221 */
/* */
             CALL       PGM(HFC0221)
 
/* */
/* Read all records on the file */
/* */
 RETRY:      RCVF
 
/* */
/* EOF */
/* */
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(FILEEND))
 
/* */
/* If file not selected then read next record */
/* */
             IF         COND(&ENAB *NE 'E') +
                          THEN(GOTO CMDLBL(RETRY))
 
/* */
/* For first file only */
/* */
             IF         COND(&COUN *EQ 0) THEN(DO)
             CHGVAR     VAR(&COUN) VALUE(1)
             CHGVAR     VAR(&OFFILE) VALUE(&FFILE)
             ENDDO
 
             IF         COND(&FFILE *NE &OFFILE) THEN(DO)
 
 
/* */
/* Build the CPYF variable */
/* */
             CHGVAR     VAR(&Z) VALUE('CPYF FROMFILE(' *TCAT &HFLIB +
                          *TCAT '/XX) TOFILE(' *TCAT &HFLIB *TCAT +
                          '/' *TCAT &OFFILE *TCAT ') TOMBR(JRNTEMP) +
                          MBROPT(*ADD) CRTFILE(*YES) FMTOPT(*NOCHK) +
                          INCREL' *TCAT &Z *TCAT ')')
 
/* */
/* Execute the parameter using QCMDEXC */
/* */
             CALL       PGM(QCMDEXC) PARM(&Z 5000)
 
 
/* */
/* Copy the JRNTEMP member to the JRNFIL member */
/* */
             CPYF       FROMFILE(&HFLIB/&OFFILE) +
                          TOFILE(&HFLIB/&OFFILE) FROMMBR(JRNTEMP) +
                          TOMBR(JRNFIL) MBROPT(*ADD) FMTOPT(*NOCHK)
 
             CHGVAR     VAR(&OFFILE) VALUE(&FFILE)
 
/* */
/* Rebuild the CPYF variable again */
/* */
             CHGVAR     VAR(&Z) VALUE('(')
             CHGVAR     VAR(&TT) VALUE(0)
             ENDDO
 
/* */
/* If file was copied */
/* */
             IF         COND(&TT *EQ 0) THEN(DO)
             CHGVAR     VAR(&Z) VALUE(&Z *BCAT '(*IF ')
             ENDDO
 
             ELSE       CMD(DO)
             CHGVAR     VAR(&Z) VALUE(&Z *BCAT '(*OR ')
             ENDDO
 
             CHGVAR     VAR(&Z) VALUE(&Z *BCAT 'JOOBJ *EQ ' *BCAT +
                          &FFORM *TCAT ')')
             CHGVAR     VAR(&TT) VALUE(1)
 
/* */
/* Read next record */
/* */
             GOTO       CMDLBL(RETRY)
 FILEEND:
 
/*                                                                     102670 */
/* If a record was read from the file,                                 102670 */
/*                                                                     102670 */
             IF         COND(&COUN *NE 0) THEN(DO)                  /* 102670 */
/* */
/* Build the CPYF variable */
/* */
             CHGVAR     VAR(&Z) VALUE('CPYF FROMFILE(' *TCAT &HFLIB +
                          *TCAT '/XX) TOFILE(' *TCAT &HFLIB *TCAT +
                          '/' *TCAT &OFFILE *TCAT ') TOMBR(JRNTEMP) +
                          MBROPT(*ADD) CRTFILE(*YES) FMTOPT(*NOCHK) +
                          INCREL' *TCAT &Z *TCAT ')')
 
/* */
/* Execute the parameter using QCMDEXC */
/* */
             CALL       PGM(QCMDEXC) PARM(&Z 5000)
 
 
/* */
/* Copy the JRNTEMP member to the JRNFIL member */
/* */
             CPYF       FROMFILE(&HFLIB/&OFFILE) +
                          TOFILE(&HFLIB/&OFFILE) FROMMBR(JRNTEMP) +
                          TOMBR(JRNFIL) MBROPT(*ADD) FMTOPT(*NOCHK)
             ENDDO                                                  /* 102670 */
 
             GOTO       CMDLBL(END)
/* */
/** ABNORMAL ERROR PROCESSING                                      */
/* */
 ABNOR:      SNDPGMMSG  MSG('PROGRAM HFC0220 ENDED ABNORMALLY') +
                          TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
