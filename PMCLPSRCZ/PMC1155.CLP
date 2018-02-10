/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas Extrct Mature/Flat Pos.for Pool Prtflios')      */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Portfolio Management Module                     */
/*                                                                   */
/*       PMC1155 -  PM Mature Flat Position For Pool Portfolio       */
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
/*       Prev Amend No. S01486             Date 10Aug94              */
/*                      056460             Date 07Jun93              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       S01486 - Portfolio Management Upgrade to Release 10.        */
/*       056460 - FIX TO ALLOW PERFORMANCE ON POOL PORTFOLIOS        */
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
             DCL        VAR(&DATA) TYPE(*CHAR) LEN(52)
 
/* SET OFF SWITCHES */
             CHGJOB     SWS(00000000)
 
/* SELECT MATURE / FLAT POSITIONS FOR POOL MEMBERS */
/**********  OVRDBF     FILE(PMPPTHQ1) TOFILE(PMMFHLPP) SHARE(*YES)*/ /*S01486*/
             OVRDBF     FILE(PMPPTHQ1) TOFILE(PMMFHLPD) SHARE(*YES)   /*S01486*/
             OVRDBF     FILE(PMMFHLL2) SHARE(*NO)
 
/**********  OPNQRYF    FILE(PMMFHLPP PMPPTMPD) +                     /*S01486*/
/**********             FORMAT(PMPPTHQ1) KEYFLD(PMPPTMPD/OSPCNU +     /*S01486*/
/**********             PMPPTMPD/OSPPTF PMMFHLPP/QFRECI +             /*S01486*/
/**********             PMMFHLPP/QFTVDA PMMFHLPP/QFMODI +             /*S01486*/
/**********             PMMFHLPP/QFBYSF PMMFHLPP/QFTDSS +             /*S01486*/
/**********             PMMFHLPP/QFFOIS PMMFHLPP/QFCCY1 +             /*S01486*/
/**********             PMMFHLPP/QFCCY2 PMMFHLPP/QFINNR +             /*S01486*/
/**********             PMMFHLPP/QFTXT1 PMMFHLPP/QFTXT2 +             /*S01486*/
/**********             PMMFHLPP/QFBFXR PMMFHLPP/QFOPCL +             /*S01486*/
/**********             PMMFHLPP/QFMFMD) +                            /*S01486*/
/**********             JFLD((PMPPTMPD/OSCNUM PMMFHLPP/QFCNUM) +      /*S01486*/
/**********             (PMPPTMPD/OSPTFR PMMFHLPP/QFPTFR))            /*S01486*/
 
             OPNQRYF    FILE(PMMFHLPD PMPPTMPD) +
                        FORMAT(PMPPTHQ1) KEYFLD(PMPPTMPD/OSPCNU +
                        PMPPTMPD/OSPPTF PMMFHLPD/QFRECI +
                        PMMFHLPD/QFTVDA PMMFHLPD/QFMODI +
                        PMMFHLPD/QFBYSF PMMFHLPD/QFTDSS +
                        PMMFHLPD/QFFOIS PMMFHLPD/QFCCY1 +
                        PMMFHLPD/QFCCY2 PMMFHLPD/QFINNR +
                        PMMFHLPD/QFTXT1 PMMFHLPD/QFTXT2 +
                        PMMFHLPD/QFBFXR PMMFHLPD/QFOPCL +
                        PMMFHLPD/QFMFMD) +
                        JFLD((PMPPTMPD/OSCNUM PMMFHLPD/QFCNUM) +
                        (PMPPTMPD/OSPTFR PMMFHLPD/QFPTFR))            /*S01486*/
/**/
/* CALL PROGRAM TO EXTRACT MATURE / FLAT POSITIONS                   */
             CALL       PGM(PM1155)
 
/**********  CLOF       OPNID(PMMFHLPP)                               /*S01486*/
             CLOF       OPNID(PMMFHLPD)                               /*S01486*/
 
             DLTOVR     FILE(*ALL)
 
/* PROCESS DATA BASE ERROR */
 ERROR:      IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&DATA)
/**********     SNDPGMMSG  MSGID(PEM0001) MSGF(CEUSRMSG) MSGDTA(&DATA)/*S01486*/
/**********                  TOMSGQ(MOPERQ MRUNQ)                **/  /*S01486*/
                SNDPGMMSG  MSGID(PEM0001) MSGF(PMUSRMSG) MSGDTA(&DATA) +
                             TOMSGQ(MOPERQ MRUNQ)                     /*S01486*/
             GOTO ENDPGM
             ENDDO
 
/* CHECK FOR FILE CONTROL ERRORS TRAPPED BY THE PROGRAM */
             IF         COND(%SWITCH(XXXXXX01)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&DATA)
/**********     SNDPGMMSG  MSGID(PEM0002) MSGF(CEUSRMSG) MSGDTA(&DATA)/+S01486*/
/**********                  TOMSGQ(MOPERQ MRUNQ)                **/  /*S01486*/
                SNDPGMMSG  MSGID(PEM0002) MSGF(PMUSRMSG) MSGDTA(&DATA) +
                             TOMSGQ(MOPERQ MRUNQ)                     /*S01486*/
             GOTO ENDPGM
             ENDDO
 
/**********  ENDPGM          ***/                                     /*S01486*/
ENDPGM:      CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
