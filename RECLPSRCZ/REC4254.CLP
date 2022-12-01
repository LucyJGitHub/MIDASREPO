/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas RE Upload Bureau de Change rate table')         */
/*********************************************************************/
/*                                                                   */
/*       Midas - Retail Module                                   */
/*                                                                   */
/*       REC4254   - Upload Bureau de Change Rate Table              */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD027509           Date 10Oct22              */
/*       Prev Amend No. CSC059             Date 10Oct22              */
/*                      MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CRT001  *CREATE    DATE 28FEB95              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD027509 - Change folder calculation to use absolute path.  */
/*                  Applied for MD-38096                             */
/*       CSC059 - Replace QDLS processing by IFS                     */
/*       MD046248 - Finastra Rebranding                              */
/*       CRT001  -  Retail Teller System                             */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&RSEQ &RLEV &RENT)
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)
             DCL        VAR(&FILE) TYPE(*CHAR) LEN(50)                                    /*CSC059*/
             DCL        VAR(&IASP_YN) TYPE(*CHAR) LEN(1)                                  /*CSC059*/
             DCL        VAR(&IASP) TYPE(*CHAR) LEN(10)                                    /*CSC059*/
             DCL        VAR(&ZSUBDIR) TYPE(*CHAR) LEN(200)                                /*CSC059*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7) VALUE('*VERIFY')                    /*CSC059*/
             DCL        VAR(&RTNC) TYPE(*CHAR) LEN(7) VALUE('       ')                    /*CSC059*/
             DCL        VAR(&SAR) TYPE(*CHAR) LEN(6) VALUE('CSC059')                      /*CSC059*/
             DCL        VAR(&SARREC) TYPE(*CHAR) LEN(200)                                 /*CSC059*/
             DCL        VAR(&CSC059) TYPE(*CHAR) LEN(1) VALUE('N' )                       /*CSC059*/
/*/COPY GPCPYSRCG,GPSVALDCL                                          */                   /*CSC059*/
/**/
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
/*                                                                                        /*CSC059*/
/* Check if feature CSC059 is on */                                                       /*CSC059*/
             CALL       PGM(AOSARDR0) PARM(&RTNC &OPTN &SAR &SARREC)                      /*CSC059*/
             IF         COND(&RTNC *EQ '       ') THEN(CHGVAR +
                          VAR(&CSC059) VALUE('Y'))                                        /*CSC059*/
                                                                                          /*CSC059*/
/* If CSC059 is on, check IASP */                                                         /*CSC059*/
             IF         COND(&CSC059 *EQ 'Y') THEN(DO)                                    /*CSC059*/
/*                                                                                        /*CSC059*/
/*  Get the global IASP system values */                                                  /*CSC059*/
/*                                                                                        /*CSC059*/
             CALL       PGM(GPAOSVALR0) PARM(&RSVALRTNC +
                          'IASPinstallation' &SVAL1 'IASPgroup' +
                          &SVAL2 &SVALK3 &SVAL3 &SVALK4 &SVAL4 +
                          &SVALK5 &SVAL5 &SVALK6 &SVAL6 &SVALK7 +
                          &SVAL7 &SVALK8 &SVAL8 &SVALK9 &SVAL9 +
                          &SVALK10 &SVAL10)                                               /*CSC059*/
/*                                                                                          CSC059*/
/** Check whether system is in IASP environment.                                            CSC059*/
/*                                                                                          CSC059*/
             CHGVAR     VAR(&IASP_YN) VALUE(%SST(&SVAL1 1 1))                             /*CSC059*/
/*                                                                                          CSC059*/
/*  If IASP environment,                                                                    CSC059*/
/*                                                                                          CSC059*/
             IF         COND(&IASP_YN *EQ 'Y') THEN(DO)                                   /*CSC059*/
/*                                                                                          CSC059*/
/*  Get name of IASP.                                                                       CSC059*/
/*                                                                                          CSC059*/
             CHGVAR     VAR(&IASP) VALUE(%SST(&SVAL2 1 10))                               /*CSC059*/
             ENDDO                                                                        /*CSC059*/
                                                                                          /*CSC059*/
/** Get the zone IFS subdirectory system value */                                         /*CSC059*/
/*                                                                                        /*CSC059*/
             CALL       PGM(AOSVALR0) PARM(&RSVALRTNC +
                          'ZoneIFSsubdirectory' &SVAL1 &SVALK2 +
                          &SVAL2 &SVALK3 &SVAL3 &SVALK4 &SVAL4 +
                          &SVALK5 &SVAL5 &SVALK6 &SVAL6 &SVALK7 +
                          &SVAL7 &SVALK8 &SVAL8 &SVALK9 &SVAL9 +
                          &SVALK10 &SVAL10)                                               /*CSC059*/
                                                                                          /*CSC059*/
/** Determine IFS subdirectory. */                                                        /*CSC059*/
             CHGVAR     VAR(&ZSUBDIR) VALUE(%SST(&SVAL1 1 200))                           /*CSC059*/
/*                                                                                        /*CSC059*/
             ENDDO                                                                        /*CSC059*/
/*                                                                   */
/* Copy Bureau de Change rate table from folder to PF/REBDCFPD       */
/*                                                                   */
             IF         COND(&CSC059 *EQ 'Y') THEN(DO)                                    /*CSC059*/
             IF         COND(&IASP_YN *EQ 'Y') THEN(DO)                                   /*CSC059*/
             CHGVAR     VAR(&FILE) VALUE(&IASP *TCAT '/XDFLR/KL')                         /*CSC059*/
             ENDDO                                                                        /*CSC059*/
             ELSE       CMD(DO)                                                           /*CSC059*/
             CHGVAR     VAR(&FILE) VALUE('/' *CAT &ZSUBDIR *TCAT '/XDFLR/KL')             /*CSC059*/
             ENDDO                                                                        /*CSC059*/
                                                                                          /*CSC059*/
             CPYF       FROMFILE(SCFFDJW0) TOFILE(REBDCFPP) +
                           MBROPT(*REPLACE) INCREL((*IF CFFILE *EQ +
                           'REBDCFPP')) FMTOPT(*MAP *DROP)                                /*CSC059*/
                                                                                          /*CSC059*/
             CPYFRMIMPF FROMSTMF(&FILE) TOFILE(*LIBL/REBDCFPD) +
                          MBROPT(*REPLACE) RCDDLM(*CRLF) +
                          DTAFMT(*FIXED) RMVBLANK(*NONE) +
                          FLDDFNFILE(REBDCFPP)                                            /*CSC059*/
             MONMSG     MSGID(CPF0000) EXEC(DO)                                           /*CSC059*/
             SNDPGMMSG  MSG('Error in upload of currency table, +
                          check PC document XDFLR/KL') TOPGMQ(*EXT) +
                          MSGTYPE(*INFO)                                                  /*CSC059*/
             GOTO       CMDLBL(END)                                                       /*CSC059*/
             ENDDO                                                                        /*CSC059*/
             ENDDO                                                                        /*CSC059*/
             ELSE       CMD(DO)                                                           /*CSC059*/
             CPYFRMPCD  FROMFLR(XDFLR) TOFILE(REBDCFPD) FROMDOC(KL)
             MONMSG     MSGID(IWS1603)
             MONMSG     MSGID(CPF0000) EXEC(DO)
             SNDPGMMSG  MSG('Error in upload of currency table, +
                          check PC document XDFLR.KL') TOPGMQ(*EXT) +
                          MSGTYPE(*INFO)
             GOTO       CMDLBL(END)
             ENDDO
             ENDDO                                                                        /*CSC059*/

/*                                                                   */
/* Distribute rates from PF/REBDCFPD to PF/REBDCRPD                  */
/*                                                                   */
             CALL       PGM(RE4254) PARM(&RSEQ)
/**/
/*    Database error processing                                      */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
             RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
             ROLLBACK
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOMSGQ(MOPERQ)
             GOTO       CMDLBL(END)
             ENDDO

/*                                                                   */
/* Move KL to KLOLD                                                  */
/*                                                                   */
             IF         COND(&CSC059 *EQ 'Y') THEN(DO)                                    /*CSC059*/
             IF         COND(&IASP_YN *EQ 'Y') THEN(DO)                                   /*CSC059*/
/**********  CHGVAR     VAR(&FILE) VALUE(&IASP *TCAT '/XDFLR/KLOLD')         /*CSC059*/ /*MD027509*/
             CHGVAR     VAR(&FILE) VALUE('/' *CAT &IASP *TCAT '/XDFLR/KLOLD')           /*MD027509*/
             ENDDO                                                                        /*CSC059*/
             ELSE       CMD(DO)                                                           /*CSC059*/
             CHGVAR     VAR(&FILE) VALUE('/' *CAT &ZSUBDIR *TCAT '/XDFLR/KLOLD')        /*MD027509*/
             ENDDO                                                                        /*CSC059*/
             RMVLNK     OBJLNK(&FILE)                                                     /*CSC059*/
             MONMSG     MSGID(CPF0000 IWS0000)                                            /*CSC059*/
/**********  CHGVAR     VAR(&FILE) VALUE(&IASP *TCAT '/XDFLR/KL')            /*CSC059*/ /*MD027509*/
             IF         COND(&IASP_YN *EQ 'Y') THEN(DO)                                   /*CSC059*/
             CHGVAR     VAR(&FILE) VALUE('/' *CAT &IASP *TCAT '/XDFLR/KL')              /*MD027509*/
             ENDDO                                                                        /*CSC059*/
             ELSE       CMD(DO)                                                           /*CSC059*/
             CHGVAR     VAR(&FILE) VALUE('/' *CAT &ZSUBDIR *TCAT '/XDFLR/KL')           /*MD027509*/
             ENDDO                                                                        /*CSC059*/
             RNM        OBJ(&FILE) NEWOBJ('KLOLD')                                        /*CSC059*/
             ENDDO                                                                        /*CSC059*/
             ELSE       CMD(DO)                                                           /*CSC059*/
             DLTDLO     DLO(KLOLD) FLR(XDFLR)
             MONMSG     MSGID(CPF0000)
             RNMDLO     DLO(KL) NEWDLO(KLOLD) FLR(XDFLR)
             ENDDO                                                                        /*CSC059*/

             GOTO       CMDLBL(END)

ABNOR:
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 MCH0000)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          REC4254 ended abnormally - see job log') +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 MCH0000)
/*                                                                   */
/* End                                                               */
/*                                                                   */
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
