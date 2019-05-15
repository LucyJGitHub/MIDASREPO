/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SE Combine Position Settlements')               */
/*********************************************************************/
/*                                                                   */
/*       Midas - Securities Trading Module                       */
/*                                                                   */
/*       SEC0606G - COMBINE POSITION SETTLEMENTS                     */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.02 ---------------------------------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. CEU017             Date 03Mar98              */
/*                      CSE007             Date 03Feb98              */
/*                      S01408             DATE 11MAY95              */
/*                      S01496             DATE 24OCT94              */
/*                      S01117             DATE 08JAN91              */
/*                      S01189             DATE 08JAN91              */
/*                      E18447             DATE 25/05/89             */
/*                      E16876             DATE 17/03/89             */
/*                      E16870             DATE 08/03/89             */
/*                      S01158             DATE 09/05/88             */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CEU017 - Securities Redenomination Euro Changes             */
/*       CSE007 - Corporate Actions                                  */
/*       S01408 - Addition of core hook SEC0606GMS                   * *E15549*/
/*       S01496 - Incorporation of Jyske Enhancements (S10978)       */
/*       S01117 - MULTIBRANCHING                                     */
/*       S01189 - CLOSE OF BUSINESS IMPROVEMENTS PHASE 2             */
/*       E18447 - POSETA AND POSETD ARE MULTIMEMBER FILES SO FROMMBR */
/*                (*ALL) REQUIRED ON CPYF STATEMENTS.                */
/*       E16876 - PROGRAM SHOULD CREATE AND THEN DELETE THE BACKUP   */
/*                VERSIONS OF POSETD AND POSETA.                     */
/*       E16870 - SESTAT REDEFINED AS 128 BYTES.                     */
/*       S01158 - POST INCORPORATION DEVELOPMENT FIXES               */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
/************PGM                                                     * *S01189*/
             PGM        PARM(&CNAM &CSEQ)                             /*S01189*/
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**/                                                                  /*S01117*/
/*           DCLDTAARA  DTAARA(LDA)                                 *  *S01179*/
                                                                      /*S01158*/
/*           DCLDTAARA  DTAARA(SESTAT)                    *  *S01158*  *S01179*/
             DCL        VAR(&LDA)     TYPE(*CHAR)  LEN(256)           /*S01179*/
/*           DCL        VAR(&SESTAT)  TYPE(*CHAR)  LEN(256)      *S01179E16870*/
/************DCL        VAR(&SESTAT)  TYPE(*CHAR)  LEN(128)   *E16870* *S01189*/
             DCL        VAR(&SDSTAT)  TYPE(*CHAR)  LEN(256)           /*E16876*/
                                                                      /*S01158*/
             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)                /*S01189*/
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5)                  /*S01189*/
/************DCL        VAR(&BUSY) TYPE(*CHAR) LEN(3)         *S01158* *S01189*/
             DCL        VAR(&BUSY) TYPE(*CHAR) LEN(1)                 /*S01189*/
             DCL        VAR(&TOLIB)  TYPE(*CHAR) LEN(10)              /*E16876*/
             DCL        VAR(&PRE)  TYPE(*CHAR) LEN(2)                 /*E16876*/
 
/************DCL        VAR(&MEM) TYPE(*CHAR) LEN(44)                * *S01117*/
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)                 /*S01117*/
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)                 /*S01496*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7)                 /*S01496*/
             DCL        VAR(&SAR) TYPE(*CHAR) LEN(6)                  /*S01496*/
             DCL        VAR(&SCSARD) TYPE(*CHAR) LEN(200)             /*S01496*/
             DCL        VAR(&CSE007) TYPE(*CHAR) LEN(1) VALUE('N')    /*CSE007*/
             DCL        VAR(&CEU017) TYPE(*CHAR) LEN(1) VALUE('N')    /*CEU017*/
/*/COPY WNCPYSRC,SEC0606G01                                          */
/**/                                                                  /*S01496*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                   /*S01496*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                   /*S01496*/
             CHGVAR     VAR(&SAR) VALUE('S01496')                     /*S01496*/
 
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&PRE)             /*E16876*/
/************CHGVAR    VAR(&TOLIB) VALUE(&PRE *TCAT 'DLIB')     *E16876 S01117*/
             CHGVAR    VAR(&TOLIB) VALUE(&PRE *TCAT 'DPLIB')          /*S01117*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,SEC0606GMS                                          */
                                                                      /*S01408*/
/* SEND START MESSAGE */
 
             CHGVAR     VAR(&MEM) VALUE('SEC0606G - Combine Position +
                          Settlements')
 
             SNDPGMMSG  MSG(&MEM) TOMSGQ(MRUNQ)
 
/*/COPY WNCPYSRC,SEC0606G02                                          */
/* CHECK FOR COMPONENT RESTART                                      *  *S01158*/
                                                                      /*S01158*/
/********    RTVDTAARA  DTAARA(SESTAT (1 3)) RTNVAR(&BUSY)    *S01158* *S01189*/
             CHGVAR     VAR(&BUSY) VALUE(' ')                         /*S01189*/
             CALL       CB0160 PARM(&CNAM &CSEQ &BUSY)                /*S01189*/
                                                                      /*S01158*/
/* IF RESTART, COPY FILES                                           *  *S01158*/
                                                                      /*S01158*/
/************IF COND(&BUSY = 'NEW') THEN(DO)                  *S01158* *S01189*/
             IF COND(&BUSY = 'Y') THEN(DO)                            /*S01189*/
                                                                      /*S01158*/
/*                                                                    /*E18447*/
/********    CPYF       FROMFILE(XPOSETD) TOFILE(POSETD) +
/********                 FROMMBR(POSETD) TOMBR(POSETD) +
/********                 MBROPT(*REPLACE) FMTOPT(*NONE)              /*S01158*/
             CPYF       FROMFILE(XPOSETD) TOFILE(POSETD) +
                          FROMMBR(*ALL) TOMBR(*FROMMBR) +
                          MBROPT(*REPLACE) FMTOPT(*NONE) /*E18774*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(POSETD) MBR(POSETD))                   /*S01158*/
                                                                      /*S01158*/
/*/COPY WNCPYSRC,SEC0606G08                                          */
/*                                                                    /*E18447*/
/*********   CPYF       FROMFILE(XPOSETA) TOFILE(POSETA) +            /*E18447*/
/*********                FROMMBR(POSETA) TOMBR(POSETA) +             /*E18447*/
/*********                MBROPT(*REPLACE) FMTOPT(*NONE)              /*E18447*/
             CPYF       FROMFILE(XPOSETA) TOFILE(POSETA) +
                          FROMMBR(*ALL) TOMBR(*FROMMBR) +
                          MBROPT(*REPLACE) FMTOPT(*NONE) /*E18447*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(POSETA) MBR(POSETA))                   /*S01158*/
/*/COPY WNCPYSRC,SEC0606G03                                          */
                                                                      /*S01158*/
/* CHANGE DATA AREA                     */                            /*S01158*/
                                                                      /*S01158*/
/***************CHGDTAARA DTAARA(SESTAT (1 3)) VALUE('OLD')   *S01158* *S01189*/
                CHGVAR    VAR(&BUSY) VALUE('N')                       /*S01189*/
                CALL      CB0150 PARM(&CNAM &CSEQ &BUSY)              /*S01189*/
                                                                      /*S01158*/
             ENDDO                                                    /*S01158*/
                                                                      /*S01158*/
/*  ELSE BACKUP FILES                                               *  *S01158*/
                                                                      /*S01158*/
             ELSE       CMD(DO)                                       /*S01158*/
                                                                      /*S01158*/
/*           CPYF       FROMFILE(POSETD) TOFILE(XPOSETD) +             *E16876*/
/*                        FROMMBR(POSETD) TOMBR(POSETD) +              *E16876*/
/*                                                                    /*E18447*/
/********    CPYF       FROMFILE(POSETD) TOFILE(&TOLIB/XPOSETD) +     /*E18447*/
/********                MBROPT(*REPLACE) FMTOPT(*NONE) CRTFILE(*YES) /*E18447*/
             CPYF       FROMFILE(POSETD) TOFILE(&TOLIB/XPOSETD) +
                          FROMMBR(*ALL) TOMBR(*FROMMBR) +
                          MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NONE)
/*                                                                    /*E18447*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(XPOSETD))                              /*S01158*/
/*           CPYF       FROMFILE(POSETA) TOFILE(XPOSETA) +             *E16876*/
/*                        FROMMBR(POSETA) TOMBR(POSETA) +              *E16876*/
/*                        MBROPT(*REPLACE) FMTOPT(*NONE)   /*S01158*/ /*E16876*/
/*                                                                    /*E18447*/
/*********   CPYF       FROMFILE(POSETA) TOFILE(&TOLIB/XPOSETA) +     /*E18447*/
/*********               MBROPT(*REPLACE) FMTOPT(*NONE) CRTFILE(*YES) /*E18447*/
             CPYF       FROMFILE(POSETA) TOFILE(&TOLIB/XPOSETA) +
                          FROMMBR(*ALL) TOMBR(*FROMMBR) +
                          MBROPT(*REPLACE) CRTFILE(*YES) +
                          FMTOPT(*NONE) /*E18447*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(XPOSETA))                              /*S01158*/
                                                                      /*S01158*/
/*/COPY WNCPYSRC,SEC0606G04                                          */
             ENDDO                                                    /*S01158*/
                                                                      /*S01158*/
/*  CHANGE DATA AREA TO 'NEW'                                       *  *S01158*/
                                                                      /*S01158*/
/************CHGDTAARA  DTAARA(SESTAT (1 3)) VALUE('NEW')     *S01158* *S01189*/
             CHGVAR     VAR(&BUSY) VALUE('Y')                         /*S01189*/
             CALL       CB0150 PARM(&CNAM &CSEQ &BUSY)                /*S01189*/
                                                                      /*S01158*/
                                                                      /*S01158*/
                                                                      /*S01158*/
/* COPY EACH OF THE FOUR MEMBERS TO POSETD, MEMBER POSETD.   */       /*S01158*/
/**CLEAR*PF*POSETD*MEMBER*POSETD*AND*POSETA*MEMBER*POSETA*PRIOR*TO +
 ***ANY*PROCESSING.**********/                                        /*S01158*/
/*****                                                    *****/      /*S01158*/
/*****       CLRPFM POSETD POSETD                         *****/      /*S01158*/
/*****       CLRPFM POSETA POSETA                         *****/      /*S01158*/
/*****                                                    *****/      /*S01158*/
/**COPY*EACH*OF*THE*FOUR*MEWMBERS*TO*POSETD,*MEMBER*POSETD.****/      /*S01158*/
 
             CPYF       FROMFILE(POSETD) TOFILE(POSETD) +
                          FROMMBR(CPOSN1) TOMBR(POSETD) MBROPT(*ADD)
 
             CPYF       FROMFILE(POSETD) TOFILE(POSETD) +
                          FROMMBR(CPOSN2) TOMBR(POSETD) MBROPT(*ADD)
 
             CPYF       FROMFILE(POSETD) TOFILE(POSETD) +
                          FROMMBR(DPOSN1) TOMBR(POSETD) MBROPT(*ADD)
 
             CPYF       FROMFILE(POSETD) TOFILE(POSETD) +
                          FROMMBR(DPOSN2) TOMBR(POSETD) MBROPT(*ADD)
/*/COPY WNCPYSRC,SEC0606G05                                          */
/**/                                                                  /*S01496*/
/**  If Jyske Enhancements is installed, add member REDEMP */         /*S01496*/
/**/                                                                  /*S01496*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD)  /*S01496*/
             IF         COND(&RTCD *EQ '       ') THEN(DO)            /*S01496*/
                CPYF       FROMFILE(POSETD) TOFILE(POSETD) +
                             FROMMBR(REDEMP) TOMBR(POSETD) +
                             MBROPT(*ADD)                             /*S01496*/
/*/COPY WNCPYSRC,SEC0606G06                                          */
             ENDDO                                                    /*S01496*/
/**/                                                                  /*CSE007*/
/**  If Corporate Action is installed, add member CORPAC */           /*CSE007*/
/**/                                                                  /*CSE007*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                   /*CSE007*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                   /*CSE007*/
             CHGVAR     VAR(&SAR) VALUE('CSE007')                     /*CSE007*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD)  /*CSE007*/
             IF         COND(&RTCD *EQ '       ') THEN(DO)            /*CSE007*/
                   CHGVAR     VAR(&CSE007) VALUE('Y')                 /*CSE007*/
             ENDDO                                                    /*CSE007*/
                                                                      /*CSE007*/
/**/                                                                  /*CEU017*/
/**  If Securities Redenomination is installed, add member CORPAC */  /*CEU017*/
/**/                                                                  /*CEU017*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                   /*CEU017*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                   /*CEU017*/
             CHGVAR     VAR(&SAR) VALUE('CEU017')                     /*CEU017*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD)  /*CEU017*/
             IF         COND(&RTCD *EQ '       ') THEN(DO)            /*CEU017*/
                   CHGVAR     VAR(&CEU017) VALUE('Y')                 /*CEU017*/
             ENDDO                                                    /*CEU017*/
                                                                      /*CEU017*/
 /***********IF         COND(&CSE007 *EQ 'Y') THEN(DO)         /*CSE007 CEU017*/
             IF         COND((&CSE007 *EQ 'Y') *OR +
                            (&CEU017 *EQ 'Y')) THEN(DO)               /*CEU017*/
                CPYF       FROMFILE(POSETD) TOFILE(POSETD) +
                             FROMMBR(CORPAC) TOMBR(POSETD) +
                             MBROPT(*ADD)                             /*CSE007*/
             ENDDO                                                    /*CSE007*/
 
/* CLEAR SWITCHES */
 
             CHGJOB     SWS(00000000)
 
/* CALL COMBINE POSITION SETTLEMENTS AUDITS PROGRAM   */
 
             CALL       PGM(SE2580)
 
/* IF EXTERNAL SWITCHES U7 AND U8 ON, RECOVER DATA FROM LDA */
/* AND SEND ERROR MESSAGES */
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/*********** RCVDTAARA  DTAARA(LDA) *********************************  *SO1179*/
             RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)                      /*S01179*/
/************CHGVAR     VAR(&MEM) VALUE(%SUBSTRING(&LDA 134 44))     * *S01117*/
             CHGVAR     VAR(&MEM) VALUE(%SUBSTRING(&LDA 134 50))      /*S01117*/
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOMSGQ(MRUNQ MOPERQ)
             CHGVAR     VAR(&MEM) VALUE('SEC0606G - Database Error')
             SNDPGMMSG  MSG(&MEM) TOMSGQ(MRUNQ MOPERQ)
             GOTO       ENDPROGRAM
             ENDDO
 
/* IF EXTERNAL SWITCH U8 ON, SEND 'FILES OUT OF BALANCE' MESSAGE */
 
             IF         COND(%SWITCH(XXXXXX01)) THEN(DO)
             CHGVAR     VAR(&MEM) VALUE('SEC0606G - File Controls Out +
                          of Balance')
             SNDPGMMSG  MSG(&MEM) TOMSGQ(MRUNQ MOPERQ)
             GOTO       ENDPROGRAM
             ENDDO
 
/* NORMAL COMPLETION - RESET BUSY FLAG */                             /*S01158*/
                                                                      /*S01158*/
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)              /*S01158*/
                                                                      /*S01158*/
/* CHANGE DATA AREA   TO 'OLD'          */                            /*S01158*/
                                                                      /*S01158*/
/***************CHGDTAARA DTAARA(SESTAT (1 3)) VALUE('OLD')   *S01158* *S01189*/
                CHGVAR    VAR(&BUSY) VALUE('N')                       /*S01189*/
                CALL      CB0150 PARM(&CNAM &CSEQ &BUSY)              /*S01189*/
             DLTF       FILE(XPOSETD)                                 /*E16876*/
                MONMSG MSGID(CPF0000)                                 /*E16876*/
             DLTF       FILE(XPOSETA)                                 /*E16876*/
                MONMSG MSGID(CPF0000)                                 /*E16876*/
                                                                      /*S01158*/
/*/COPY WNCPYSRC,SEC0606G07                                          */
                ENDDO                                                 /*S01158*/
                                                                      /*S01158*/
/**NO*ERRORS*HAVE*OCCURRED*AT*THIS*POINT,*SO*CLEAR*ALL*OF*THE*SOURCE +
 **MEMBERS*OF*POSETD*&*POSETA.**** */                                 /*S01158*/
/*                                                               */   /*S01158*/
/*           CLRPFM     FILE(POSETD) MBR(CPOSN1)                 */   /*S01158*/
/*           CLRPFM     FILE(POSETD) MBR(CPOSN2)                 */   /*S01158*/
/*           CLRPFM     FILE(POSETD) MBR(DPOSN1)                 */   /*S01158*/
/*           CLRPFM     FILE(POSETD) MBR(DPOSN2)                 */   /*S01158*/
/*                                                               */   /*S01158*/
/*           CLRPFM     FILE(POSETA) MBR(CPOSN1)                 */   /*S01158*/
/*           CLRPFM     FILE(POSETA) MBR(CPOSN2)                 */   /*S01158*/
/*           CLRPFM     FILE(POSETA) MBR(DPOSN1)                 */   /*S01158*/
/*           CLRPFM     FILE(POSETA) MBR(DPOSN2)                 */   /*S01158*/
 
 
/*ENDPROGRAM:******ENDPGM                                            * *S01117*/
ENDPROGRAM:  CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM                                                   /*S01117*/
