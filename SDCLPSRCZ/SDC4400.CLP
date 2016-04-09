/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SD BTS COB end-of-year component')              */
/*********************************************************************/
/*                                                                   */
/*       Midas - Standing Data Module                        */
/*                                                                   */
/*       Business Transaction Statistics Switchable Feature          */
/*                                                                   */
/*       SDC4400  - BTS End-of-Year component                        */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*       Last amend no. BG18886            Date 22May08              */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. S01408             Date 10May95              */
/*                      S01411             Date 26Apr93              */
/*                                         DATE                      */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       BG18886 - Amend non-standard codes                          */
/*       S01408 - Addition of core hook SDC4400MP1                   */
/*       S01411 - New program for BTS                                */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&CNAM &CSEQ)
 
             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5 0)
             DCL        VAR(&STAT) TYPE(*CHAR) LEN(1)
 
             DCL        VAR(&SDSTAT) TYPE(*CHAR) LEN(256)
             DCL        VAR(&DPLIB) TYPE(*CHAR) LEN(7)
             DCL        VAR(&LIBR) TYPE(*CHAR) LEN(2)
 
             DCL        VAR(&FEOY) TYPE(*CHAR) LEN(1)
             DCL        VAR(&ERROR) TYPE(*CHAR) LEN(1)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/* */
/* Global monitor */
/* */
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
/* */
/* Change the switches U7 & U8 off */
/* */
             CHGJOB     SWS(XXXXXX00)
/* */
             SNDPGMMSG  MSG('SDC4400 - BTS COB End-of-year +
                          processing') TOMSGQ(MRUNQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
/* Determine Library prefix from SDSTAT */
/* */
                 RTVDTAARA  DTAARA(SDSTAT) RTNVAR(&SDSTAT)
                 CHGVAR     VAR(&LIBR) VALUE(%SST(&SDSTAT 6 2))
                 CHGVAR     VAR(&DPLIB) VALUE(&LIBR *TCAT 'DPLIB')
                                                                      /*S01408*/
/*/COPY WNCPYSRC,SDC4400MP1                                          */
                                                                      /*S01408*/
/**/
/* CALL SD2001 TO DETERMINE WHETHER END OF YEAR               */
/**/
             CALL       PGM(SD2001) PARM(&FEOY &ERROR)
             IF         COND(&ERROR *EQ 'Y') THEN(GOTO CMDLBL(ABNOR))
/************IF*********COND(&FEOY****'Y') THEN(GOTO CMDLBL(END))**/  /*BG18886*/
             IF         COND(&FEOY *NE 'Y') THEN(GOTO CMDLBL(END))    /*BG18886*/
/* */
/* Check to see if this is a restart */
/* */
             CALL       PGM(CB0160) PARM(&CNAM &CSEQ &STAT)
/* */
/* If this is not a restart then seton the restart flag */
/* */
             IF         COND(&STAT *EQ 'N') THEN(DO)
                CHGVAR     VAR(&STAT) VALUE('Y')
                CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STAT)
             ENDDO
/* */
/* If this is a restart then run the restart processing */
/* */
             ELSE       CMD(DO)
 
/* */
/* If Security copies exists clear the Historic files */
/* Copy the details from the security copies to the Historic files */
/* */
                CHKOBJ     OBJ(&DPLIB/XSDBTFHPD) OBJTYPE(*FILE)
                MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(CHK2))
 
                CLRPFM     FILE(SDBTFHPD)
                CPYF       FROMFILE(&DPLIB/XSDBTFHPD) TOFILE(SDBTFHPD) +
                            TOMBR(*FIRST) MBROPT(*REPLACE)
                MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                            FILE(SDBTFHPD))
 
CHK2:
                CHKOBJ     OBJ(&DPLIB/XSDBTMHPD) OBJTYPE(*FILE)
                MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(CEND))
 
                CLRPFM     FILE(SDBTMHPD)
                CPYF       FROMFILE(&DPLIB/XSDBTMHPD) TOFILE(SDBTMHPD) +
                            TOMBR(*FIRST) MBROPT(*REPLACE)
                MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                            FILE(SDBTMHPD))
 
CEND:
             ENDDO
/* */
/* Normal Processing */
/* */
/* Create Security copies of Historic files */
/* */
 
             DLTF       FILE(&DPLIB/XSDBTFHPD)
             MONMSG     MSGID(CPF2105)
 
             CPYF       FROMFILE(SDBTFHPD) TOFILE(&DPLIB/XSDBTFHPD) +
                          MBROPT(*REPLACE) CRTFILE(*YES)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)
 
             DLTF       FILE(&DPLIB/XSDBTMHPD)
             MONMSG     MSGID(CPF2105)
 
             CPYF       FROMFILE(SDBTMHPD) TOFILE(&DPLIB/XSDBTMHPD) +
                          MBROPT(*REPLACE) CRTFILE(*YES)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)
 
/* */
/* Copy data from Current files to Historic files */
/* */
 
             CPYF       FROMFILE(SDBTSFPD) TOFILE(SDBTFHPD) +
                          MBROPT(*ADD) FMTOPT(*NOCHK)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)
 
             CPYF       FROMFILE(SDBTSMPD) TOFILE(SDBTMHPD) +
                          MBROPT(*ADD) FMTOPT(*NOCHK)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)
 
/* */
/* Clear data from Current files */
/* */
             CLRPFM     FILE(SDBTSFPD)
 
             CLRPFM     FILE(SDBTSMPD)
 
/* */
/* Delete Security copies of Historic files */
/* */
 
             DLTF       FILE(&DPLIB/XSDBTFHPD)
 
             DLTF       FILE(&DPLIB/XSDBTMHPD)
 
/* */
/* Reset failed component flag to 'N' on successful completion */
/* */
             CHGVAR     VAR(&STAT) VALUE('N')
             CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STAT)
 
             GOTO       CMDLBL(END)
 
/* */
/** Abnormal error processing */
/* */
 ABNOR:      SNDPGMMSG  MSG('Program SDC4400 ended abnormally') +
                          TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGJOB     SWS(XXXXXX11)
 
/* */
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
