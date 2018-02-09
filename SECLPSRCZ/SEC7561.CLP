/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SE Generation A/C Keys & Positions Settl.')     */
/*********************************************************************/
/*                                                                   */
/*       Midas - Securities Trading Module                           */
/*                                                                   */
/*       SEC7561 - SE Generation A/C Keys and Pos. Settlements       */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.03 ---------------------------------------------------*/
/*       Prev Amend No. CSE020             Date 21Mar00              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CEU017             Date 02Apr98              */
/*                      CSE007  *CREATE    Date 25Feb98              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CSE020 - Corporate Actions Domino Effect Processing to      */
/*                SECORFPD (recompile)                               */
/*       CEU017 - Securities Redenomination Euro Changes             */
/*       CSE007 - Corporate Actions                                  */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&CNAM &CSEQ)
 
/* Declare PGM Variables */
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&MEM)  TYPE(*CHAR) LEN(52)
             DCL        VAR(&MSG)  TYPE(*CHAR) LEN(65)
             DCL        VAR(&CNAM)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&CSEQ)  TYPE(*DEC) LEN(5 0)
             DCL        VAR(&STATUS)  TYPE(*CHAR) LEN(1) VALUE(' ')
             DCL        VAR(&PREFIX) TYPE(*CHAR) LEN(2)
             DCL        VAR(&DLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&ACCRX) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7) VALUE('       ') /*CEU017*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7) VALUE('*FIRST ') /*CEU017*/
             DCL        VAR(&SAR)  TYPE(*CHAR) LEN(6)                  /*CEU017*/
             DCL        VAR(&CEU017)  TYPE(*CHAR) LEN(1) VALUE('N')    /*CEU017*/
             DCL        VAR(&SCSARD) TYPE(*CHAR) LEN(200)              /*CEU017*/
/*/COPY WNCPYSRC,SEC7561001                                          */
 
/* Get system ID to build DLIB name */
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&PREFIX)
             CHGVAR     VAR(&DLIB) VALUE(&PREFIX *TCAT 'DPLIB')
 
/* Send Information Program Message */
             CHGVAR     VAR(&MSG) VALUE('SEC7561 - Gen. A/C Keys +
                          & Pos. Settl. - Dep/Cust/Book Positions')
             SNDPGMMSG  MSG(&MSG) TOMSGQ(MRUNQ) MSGTYPE(*INFO)
                                                                      /*CEU017*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                   /*CEU017*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                   /*CEU017*/
             CHGVAR     VAR(&SAR)  VALUE('CEU017')                    /*CEU017*/
                                                                      /*CEU017*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD)  /*CEU017*/
                                                                      /*CEU017*/
             IF         COND(&RTCD *EQ '       ') THEN(DO)            /*CEU017*/
                CHGVAR     VAR(&CEU017) VALUE('Y')                    /*CEU017*/
             ENDDO                                                    /*CEU017*/
/*/COPY WNCPYSRC,SEC7561002                                          */
 
/* Reset Switches */
             CHGJOB     SWS(00000000)
 
/* Clear Output Files */
             CLRPFM     FILE(SEKEYD) MBR(CORPAC)
             CLRPFM     FILE(SEKEYA) MBR(CORPAC)
             CLRPFM     FILE(POSETD) MBR(CORPAC)
             CLRPFM     FILE(POSETA) MBR(CORPAC)
 
/* Retrieve the field indicating a Restart */
             CHGVAR     VAR(&STATUS) VALUE(' ')
             CALL       CB0160 PARM(&CNAM &CSEQ &STATUS)
 
/* Override Files */
             OVRDBF     FILE(SEKEYD) MBR(CORPAC)
             OVRDBF     FILE(SEKEYA) MBR(CORPAC)
             OVRDBF     FILE(POSETD) MBR(CORPAC)
             OVRDBF     FILE(POSETA) MBR(CORPAC)
 
/* Override to SEQONLY(*YES 100) */
             OVRDBF     FILE(XSECORFPD) SEQONLY(*YES 100)
             OVRDBF     FILE(XSECODRPD) SEQONLY(*YES 100)
             OVRDBF     FILE(XSECODPPD) SEQONLY(*YES 100)
             OVRDBF     FILE(XSECOALPD) SEQONLY(*YES 100)
 
             OVRDBF     FILE(SECORFPD)  SEQONLY(*YES 100)
             OVRDBF     FILE(SECODRPD) SEQONLY(*YES 100)
             OVRDBF     FILE(SECODPPD)  SEQONLY(*YES 100)
             OVRDBF     FILE(SECOALPD)  SEQONLY(*YES 100)
                                                                      /*CEU017*/
             IF         COND(&CEU017 *EQ 'Y') THEN(DO)                /*CEU017*/
                OVRDBF     FILE(SECORBPD)  SEQONLY(*YES 100)          /*CEU017*/
                OVRDBF     FILE(XSECORBPD) SEQONLY(*YES 100)          /*CEU017*/
             ENDDO                                                    /*CEU017*/
/*/COPY WNCPYSRC,SEC7561003                                          */
 
/* If Restart, Take Security Copy of SECORFPD, SECODRPD, SECODPPD, SECOALPD  */
             IF         COND(&STATUS = 'Y') THEN(DO)
             CPYF       FROMFILE(&DLIB/XSECORFPD) TOFILE(SECORFPD) +
                          MBROPT(*REPLACE) FMTOPT(*NONE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(SECORFPD))
             CPYF       FROMFILE(&DLIB/XSECODRPD) TOFILE(SECODRPD) +
                          MBROPT(*REPLACE) FMTOPT(*NONE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(SECODRPD))
             CPYF       FROMFILE(&DLIB/XSECODPPD) TOFILE(SECODPPD) +
                          MBROPT(*REPLACE) FMTOPT(*NONE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(SECODPPD))
             CPYF       FROMFILE(&DLIB/XSECOALPD) TOFILE(SECOALPD) +
                          MBROPT(*REPLACE) FMTOPT(*NONE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(SECOALPD))
                                                                      /*CEU017*/
             IF         COND(&CEU017 *EQ 'Y') THEN(DO)                /*CEU017*/
                  CPYF       FROMFILE(&DLIB/XSECORBPD) TOFILE(SECORBPD) +
                               MBROPT(*REPLACE) FMTOPT(*NONE)         /*CEU017*/
                  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                               FILE(SECORBPD))                        /*CEU017*/
             ENDDO                                                    /*CEU017*/
                                                                      /*CEU017*/
/*/COPY WNCPYSRC,SEC7561004                                          */
             ENDDO
 
             ELSE CMD(DO)
 
/* Delete Copy Files */
             DLTF       FILE(XSECORFPD)
             MONMSG MSGID(CPF0000)
             DLTF       FILE(XSECODRPD)
             MONMSG MSGID(CPF0000)
             DLTF       FILE(XSECODPPD)
             MONMSG MSGID(CPF0000)
             DLTF       FILE(XSECOALPD)
             MONMSG MSGID(CPF0000)
                                                                      /*CEU017*/
             IF         COND(&CEU017 *EQ 'Y') THEN(DO)                /*CEU017*/
                 DLTF       FILE(XSECORBPD)                           /*CEU017*/
                 MONMSG MSGID(CPF0000)                                /*CEU017*/
             ENDDO                                                    /*CEU017*/
/*/COPY WNCPYSRC,SEC7561005                                          */
 
/* Backup File */
             CPYF       FROMFILE(SECORFPD) TOFILE(&DLIB/XSECORFPD) +
                          MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NONE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)
             CPYF       FROMFILE(SECODRPD) TOFILE(&DLIB/XSECODRPD) +
                          MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NONE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)
             CPYF       FROMFILE(SECODPPD) TOFILE(&DLIB/XSECODPPD) +
                          MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NONE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)
             CPYF       FROMFILE(SECOALPD) TOFILE(&DLIB/XSECOALPD) +
                          MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NONE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)
                                                                            /*CEU017*/
             IF         COND(&CEU017 *EQ 'Y') THEN(DO)                      /*CEU017*/
                  CPYF       FROMFILE(SECORBPD) TOFILE(&DLIB/XSECORBPD) +
                               MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NONE) /*CEU017*/
                  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)                 /*CEU017*/
             ENDDO                                                          /*CEU017*/
/*/COPY WNCPYSRC,SEC7561006                                          */
 
             CHGVAR     VAR(&STATUS) VALUE('Y')
             CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STATUS)
             ENDDO
 
             DLTOVR     FILE(XSECORFPD XSECODRPD XSECODPPD XSECOALPD SECORFPD +
                          SECODRPD SECODPPD SECOALPD)
                                                                      /*CEU017*/
             IF         COND(&CEU017 *EQ 'Y') THEN(DO)                /*CEU017*/
                  DLTOVR     FILE(XSECORBPD SECORBPD)                 /*CEU017*/
             ENDDO                                                    /*CEU017*/
/*/COPY WNCPYSRC,SEC7561007                                          */
 
             RTVDTAARA  DTAARA(SDSTAT (116 1)) RTNVAR(&ACCRX)
/* Call the Program */
             CALL       PGM(SE7561) PARM(&ACCRX)
 
/* Delete Override */
             DLTOVR     FILE(*ALL)
 
/* For Database Errors Recover Data from LDA */
 ERROR:      IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&MEM)
                SNDPGMMSG  MSGID(DBM0001) MSGF(SEUSRMSG) MSGDTA(&MEM) +
                             TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                CHGVAR VAR(&MEM) VALUE('SEC7561 - JOB TERMINATED, +
                                        DATABASE IN ERROR')
                SNDPGMMSG MSG(&MEM) TOPGMQ(*EXT) TOMSGQ(MRUNQ MOPERQ)
                GOTO ENDPGM
             ENDDO
 
/* For File in Balance Error */
             IF         COND(%SWITCH(XXXXXXX1)) THEN(DO)
                   CHGVAR     VAR(&MEM) VALUE('SEC7561 - FILE CONTROLS OUT +
                                              OF BALANCE')
                   SNDPGMMSG  MSG(&MEM) TOPGMQ(*EXT) TOMSGQ(MRUNQ MOPERQ)
                   GOTO ENDPGM
             ENDDO
 
/* If the job is completed normally */
             CHGVAR     VAR(&STATUS) VALUE('N')
             CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STATUS)
 
/* Delete Security Copy */
             DLTF       FILE(&DLIB/XSECORFPD)
             MONMSG MSGID(CPF0000)
             DLTF       FILE(&DLIB/XSECODRPD)
             MONMSG MSGID(CPF0000)
             DLTF       FILE(&DLIB/XSECODPPD)
             MONMSG MSGID(CPF0000)
             DLTF       FILE(&DLIB/XSECOALPD)
             MONMSG MSGID(CPF0000)
                                                                      /*CEU017*/
             IF         COND(&CEU017 *EQ 'Y') THEN(DO)                /*CEU017*/
                  DLTF       FILE(&DLIB/XSECORBPD)                    /*CEU017*/
                  MONMSG MSGID(CPF0000)                               /*CEU017*/
             ENDDO                                                    /*CEU017*/
/*/COPY WNCPYSRC,SEC7561008                                          */
 
             RCLRSC
 
ENDPGM:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
