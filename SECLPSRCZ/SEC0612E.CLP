/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SE Position Settlement Generated Rpt')          */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Securities Trading Module                       */
/*                                                                   */
/*       SEC0612E - POSITION SETTLEMENTS GENERATED REPORTS           */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. CEU017             DATE 06MAY98              */
/*       PREV AMEND NO. CSE007             DATE 03FEB98              */
/*                      S01496             DATE 24OCT94              */
/*                      S01117             DATE 08JAN91              */
/*                      E16870             DATE 08/03/89             */
/*                      S01179             DATE 16/12/88             */
/*                      E15483             DATE 01/11/88             */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       CEU018 - Securities Redenomination Euro Changes             */
/*       CSE007 - Corporate Actions                                  */
/*       S01496 - Incorporation of Jyske Enhancements (S10978)       */
/*       S01117 - MULTIBRANCHING                                     */
/*       E16870 - SESTAT REDEFINED AS 128 BYTES.                     */
/*       S01179 - AS400 CHANGES TO COMMAND KEYS                      */
/*       E15483 - REMOVE COPY FILE PROCESSING                        */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/**/                                                                  /*S01117*/
             DCL        VAR(&LDA)     TYPE(*CHAR)  LEN(256)
/*           DCL        VAR(&SESTAT)  TYPE(*CHAR)  LEN(256)            *E16870*/
/************DCL        VAR(&SESTAT)  TYPE(*CHAR)  LEN(128)   *E16870* *S01117*/
 
/************DCL        VAR(&MEM)  TYPE(*CHAR) LEN(60)               * *S01117*/
             DCL        VAR(&MEM)  TYPE(*CHAR) LEN(50)                /*S01117*/
             DCL        VAR(&BUSY)  TYPE(*CHAR) LEN(3)
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)                 /*S01496*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7)                 /*S01496*/
             DCL        VAR(&SAR) TYPE(*CHAR) LEN(6)                  /*S01496*/
             DCL        VAR(&SCSARD) TYPE(*CHAR) LEN(200)             /*S01496*/
             DCL        VAR(&CSE007) TYPE(*CHAR) LEN(1) VALUE('N')    /*CSE007*/
             DCL        VAR(&CEU017) TYPE(*CHAR) LEN(1) VALUE('N')    /*CEU017*/
/*/COPY WNCPYSRC,SEC0612E01                                          */
/**/                                                                  /*S01496*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                   /*S01496*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                   /*S01496*/
             CHGVAR     VAR(&SAR) VALUE('S01496')                     /*S01496*/
 
/* SETUP AND SEND PGM MESSAGE                                    */
 
             CHGVAR     VAR(&MEM) VALUE('SEC0612E - Position +
                        Settlements Generated Report')
             SNDPGMMSG  MSG(&MEM) TOMSGQ(MRUNQ) MSGTYPE(*INFO)
 
/*  CHECK FOR COMPONENT RESTART                                     */
/*                                                                  *  *E15483*/
/*           RTVDTAARA  DTAARA(SESTAT (1 3)) RTNVAR(&BUSY)          *  *E15483*/
/*                                                                  *  *E15483*/
/*  IF RESTART, COPY FILES                                          *  *E15483*/
/*                                                                  *  *E15483*/
/*           IF         COND(&BUSY = 'NEW') THEN(DO)                *  *E15483*/
/*                                                                  *  *E15483*/
/*           CPYF       FROMFILE(XPOSETD) TOFILE(POSETD) +          *  *E15483*/
/*                        FROMMBR(POSETD) TOMBR(POSETD) +           *  *E15483*/
/*                        MBROPT(*REPLACE) FMTOPT(*NONE)            *  *E15483*/
/*           MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +*  *E15483*/
/*                        FILE(POSETD) MBR(POSETD))                 *  *E15483*/
/*           CPYF       FROMFILE(XPOSETA) TOFILE(POSETA) +          *  *E15483*/
/*                        FROMMBR(POSETA) TOMBR(POSETA) +           *  *E15483*/
/*                        MBROPT(*REPLACE) FMTOPT(*NONE)            *  *E15483*/
/*           MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +*  *E15483*/
/*                        FILE(POSETA) MBR(POSETA))                 *  *E15483*/
/*                                                                  *  *E15483*/
/*  CHANGE DATA AREA TO 'OLD'                                      */
/*                                                                  *  *E15483*/
/*              CHGDTAARA  DTAARA(SESTAT (1 3)) VALUE('OLD')        *  *E15483*/
/*                                                                  *  *E15483*/
/*           ENDDO                                                  *  *E15483*/
/*                                                                  *  *E15483*/
/*  ELSE BACKUP FILES                                               */
/*                                                                  *  *E15483*/
/*           ELSE       CMD(DO)                                     *  *E15483*/
/*                                                                  *  *E15483*/
/*           CPYF       FROMFILE(POSETD) TOFILE(XPOSETD) +          *  *E15483*/
/*                        FROMMBR(POSETD) TOMBR(POSETD) +           *  *E15483*/
/*                        MBROPT(*REPLACE) FMTOPT(*NONE)            *  *E15483*/
/*              MONMSG     (CPF2817) CMPDTA(CPF2869) +              *  *E15483*/
/*                          EXEC(CLRPFM XPOSETD)                    *  *E15483*/
/*           CPYF       FROMFILE(POSETA) TOFILE(XPOSETA) +          *  *E15483*/
/*                        FROMMBR(POSETA) TOMBR(POSETA) +           *  *E15483*/
/*                        MBROPT(*REPLACE) FMTOPT(*NONE)            *  *E15483*/
/*              MONMSG     (CPF2817) CMPDTA(CPF2869) +              *  *E15483*/
/*                          EXEC(CLRPFM XPOSETA)                    *  *E15483*/
/*                                                                  *  *E15483*/
/*           ENDDO                                                  *  *E15483*/
/*                                                                  *  *E15483*/
/*  CHANGE DATA AREA TO 'NEW'                                       */
/*                                                                  *  *E15483*/
/*           CHGDTAARA  DTAARA(SESTAT (1 3)) VALUE('NEW')           *  *E15483*/
/*                                                                  *  *E15483*/
/*/COPY WNCPYSRC,SEC0612E02                                          */
/* CLEAR SWITCHES                                                */
 
             CHGJOB SWS(00000000)
 
/* CALL PROGRAM                                                  */
/*/COPY WNCPYSRC,SEC0612E05                                          */
 
             CALL       PGM(SE0640)
/*/COPY WNCPYSRC,SEC0612E06                                          */
 
/* FOR DATABASE ERRORS RECOVER DATA FROM LDA                     */
 
 ERROR:      IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/***************RTVDTAARA  DTAARA(LDA (134 44)) RTNVAR(&MEM)         * *S01117*/
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)          /*S01117*/
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM)-
                           TOMSGQ(MOPERQ MRUNQ)
                CHGVAR     VAR(&MEM) VALUE('SEC0612E - Database in Error')
                SNDPGMMSG  MSG(&MEM) TOMSGQ(MRUNQ MOPERQ)
                GOTO ENDPGM
             ENDDO
 
/* FOR FILE CONTROLS OUT OF BALANCE ERROR                        */
 
             IF         COND(%SWITCH(XXXXXX01)) THEN(DO)
                CHGVAR  VAR(&MEM) VALUE('SEC0612E - File Controls Out +
                        Of Balance')
                SNDPGMMSG  MSG(&MEM) TOMSGQ(MRUNQ MOPERQ)
                GOTO ENDPGM
             ENDDO
 
/*  IF U7 AND U8 OFF, CHANGE SESTAT TO "OLD"                       */
 
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
 
/*             CHGDTAARA  DTAARA(SESTAT (1 3)) VALUE('OLD')         *  *E15483*/
 
/*  CLEAR FILES                                                    */
 
             CLRPFM     FILE(POSETD) MBR(CPOSN1)
             CLRPFM     FILE(POSETA) MBR(CPOSN1)
             CLRPFM     FILE(POSETD) MBR(CPOSN2)
             CLRPFM     FILE(POSETA) MBR(CPOSN2)
             CLRPFM     FILE(POSETD) MBR(DPOSN1)
             CLRPFM     FILE(POSETA) MBR(DPOSN1)
             CLRPFM     FILE(POSETD) MBR(DPOSN2)
             CLRPFM     FILE(POSETA) MBR(DPOSN2)
/*/COPY WNCPYSRC,SEC0612E03                                          */
/**/                                                                  /*S01496*/
/**  If Jyske Enhancements is installed, clear member REDEMP */       /*S01496*/
/**/                                                                  /*S01496*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD)  /*S01496*/
             IF         COND(&RTCD *EQ '       ') THEN(DO)            /*S01496*/
                CLRPFM     FILE(POSETD) MBR(REDEMP)                   /*S01496*/
                CLRPFM     FILE(POSETA) MBR(REDEMP)                   /*S01496*/
/*/COPY WNCPYSRC,SEC0612E04                                          */
             ENDDO                                                    /*S01496*/
/**/                                                                  /*CSE007*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                   /*CSE007*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                   /*CSE007*/
             CHGVAR     VAR(&SAR) VALUE('CSE007')                     /*CSE007*/
/**/                                                                  /*CSE007*/
/**  If Corporate Action is installed, clear member CORPAC */         /*CSE007*/
/**/                                                                  /*CSE007*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD)  /*CSE007*/
             IF         COND(&RTCD *EQ '       ')                     /*CSE007*/
                        CHGVAR     VAR(&CSE007) VALUE('Y')            /*CSE007*/
/**/                                                                  /*CSE007*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                   /*CEU017*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                   /*CEU017*/
             CHGVAR     VAR(&SAR) VALUE('CEU017')                     /*CEU017*/
/**/                                                                  /*CEU017*/
/**  If Securities Reden. (EMU) is installed, clear member CORPAC */  /*CEU017*/
/**/                                                                  /*CEU017*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD)  /*CEU017*/
             IF         COND(&RTCD *EQ '       ')                     /*CEU017*/
                        CHGVAR     VAR(&CEU017) VALUE('Y')            /*CEU017*/
/**/                                                                  /*CEU017*/
 /***********IF         COND(&CSE007 *EQ 'Y') THEN(DO)         /*CSE007 CEU017*/
             IF         COND((&CSE007 *EQ 'Y') *OR +
                            (&CEU017 *EQ 'Y')) THEN(DO)               /*CEU017*/
                CLRPFM     FILE(POSETD) MBR(CORPAC)                   /*CSE007*/
                CLRPFM     FILE(POSETA) MBR(CORPAC)                   /*CSE007*/
             ENDDO                                                    /*CSE007*/
/*           CLRPFM     FILE(XPOSETD) MBR(POSETD)                   *  *E15483*/
/*           CLRPFM     FILE(XPOSETA) MBR(POSETA)                   *  *E15483*/
 
             ENDDO
 
/*ENDPGM:******ENDPGM                                                * *S01117*/
ENDPGM:      CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM                                                   /*S01117*/
