/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas CF MT395 chaser generation control')            */
/*********************************************************************/
/*                                                                   */
/*       Midas     - CONFIRMATION MATCHING                           */
/*                                                                   */
/*       CFC0060 - MT395 CHASER GENERATION CONTROL                   */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. CCB020             Date 06Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      CPK016             Date 04Jun03              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CPK009             Date 09Jul99              */
/*                      E43951             DATE 30SEP92              */
/*                      E38676                  21APR92              */
/*                      S01310                  06DEC90              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CCB020 - COB Restructure - Secondary COB Infrastructure     */
/*       CPK016 - Externalise STRCMTCTL code for ease of later       */
/*                upgrade.                                           */
/*       CPK009 - Packaging for DBA3 release. STRCMTCTL values set   */
/*                to CMTSCOPE(*JOB).                                 */
/*       E43951 - Remove journalling done in DLC0603                 */
/*       E38676 - Program ended abnormally. Concat coding is wrong   */
/*       S01310 - Re written for SWIFT rationalisation               */
/*                                                                   */
/*********************************************************************/
             PGM
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
             DCL        VAR(&ERRDTA) TYPE(*CHAR) LEN(50)
/**********  DCL        VAR(&MPHAS)  TYPE(*CHAR) LEN(1)                                */ /*CCB020*/
             DCL        VAR(&CBFLG)  TYPE(*CHAR) LEN(4)                                   /*CCB020*/
/************DCL        VAR(&JLIB) TYPE(*CHAR) LEN(6) */             /*E43951*/
/************DCL        VAR(&PREFIX) TYPE(*CHAR) LEN(2) */           /*E43951*/
/************                                           */           /*E43951*/
/************DCL        VAR(&SDSTAT) TYPE(*CHAR) LEN(256) */         /*E43951*/
             DCL        VAR(&CMTRTN) TYPE(*CHAR) LEN(10)                                  /*CPK016*/
 
/* Global monitor messages */
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO ABNOR)
 
/* Create LDA */
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                        TEXT('Midas SD Local Data Area')
             MONMSG     MSGID(CPF0000)
 
/**********  RTVDTAARA  DTAARA(MPHAS) RTNVAR(&MPHAS)                                   */ /*CCB020*/
             CALL       PGM(CBC001001) PARM(&CBFLG)                                       /*CCB020*/
 
/************IF         COND(&MPHAS *EQ 'C') THEN(DO) */             /*E43951*/
/************RTVDTAARA  DTAARA(SDSTAT) RTNVAR(&SDSTAT) */            /*E43951*/
/************                                          */            /*E43951*/
/************CHGVAR     VAR(&PREFIX) VALUE(%SST(&SDSTAT 6 2)) */     /*E43951*/
/*           CHGVAR     VAR(&JLIB) VALUE('&PREFIX *CAT ''JLIB''')    /*E43951*/
/************CHGVAR     VAR(&JLIB) VALUE(&PREFIX *CAT 'JLIB')    E38676E43951*/
 
/************CRTJRNRCV  JRNRCV(&JLIB/CF60RCV) */                     /*E43951*/
/************MONMSG     MSGID(CPF0000) */                            /*E43951*/
/************CRTJRN     JRN(&JLIB/CF60JRN) JRNRCV(&JLIB/CF60RCV) */  /*E43951*/
/************MONMSG     MSGID(CPF0000) */                            /*E43951*/
/************STRJRNPF   FILE(MGOREFPD MGOMSGPD CFFEEDPD CFCHSRPD) +
                          JRN(&JLIB/CF60JRN) */                      /*E43951*/
/************ENDDO */                                                /*E43951*/
 
/* Generate CHASERS */
/**********  STRCMTCTL  LCKLVL(*CHG)                                    CPK009*/
/**********  STRCMTCTL  LCKLVL(*CHG) CMTSCOPE(*JOB) */                         /*CPK009*/ /*CPK016*/
             CALL       PGM(SCCMTCTL) PARM('S' &CMTRTN)                                   /*CPK016*/
             MONMSG     MSGID(CPF8351)
 
             CALL       PGM(*LIBL/CF0060)
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
             RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&ERRDTA)
             SNDPGMMSG  MSGID(MEM0011) MSGF(MIDAS) MSGDTA(&ERRDTA) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)
             GOTO ABNOR
             ENDDO
 
/* If COB, produce audit report of CHASERS generated during the day */
/**********  IF         COND(&MPHAS *EQ 'C') THEN(DO)                                  */ /*CCB020*/
             IF         COND(&CBFLG *EQ '*YES') THEN(DO)                                  /*CCB020*/
 
             CALL       PGM(CF0065) PARM('     ')
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
             RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&ERRDTA)
             SNDPGMMSG  MSGID(MEM0011) MSGF(MIDAS) MSGDTA(&ERRDTA) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)
             GOTO ABNOR
             ENDDO
             ENDDO
 
/************IF         COND(&MPHAS *EQ 'C') THEN(DO) */             /*E43951*/
/************ENDJRNPF   FILE(*ALL) JRN(ICJRN/CF60JRN)            E38676E43951*/
/************MONMSG     MSGID(CPF0000)                           E38676E43951*/
/************DLTJRN     JRN(&JLIB/CF60JRN) */                        /*E43951*/
/************MONMSG     MSGID(CPF0000) */                            /*E43951*/
/************DLTJRNRCV  JRNRCV(&JLIB/CF60RCV) */                     /*E43951*/
/************MONMSG     MSGID(CPF0000) */                            /*E43951*/
/************ENDDO */                                                /*E43951*/
 
             GOTO END
 ABNOR:      SNDPGMMSG  MSG('CFC0060 ENDED ABNORMALLY') TOPGMQ(*EXT) +
                        TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 END:        ENDPGM
