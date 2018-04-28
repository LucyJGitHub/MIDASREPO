/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas Spot Rates Transfer To History File')           */
/********************************************************************/
/*                                                                  */
/*     Midas Standing Data Module                           */
/*                                                                  */
/*     SDC2438 - SPOT RATES HISTORY COMPONENT                       */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*     LAST AMEND NO. S01189            DATE  02MAY90               */
/*     PREV AMEND NO. E23907            DATE  16OCT90               */
/*                    S01267            DATE  18SEP90               */
/*                                                                  */
/********************************************************************/
/*        S01189 - CLOSE OF BUSINESS CHANGES                        */
/*        E23907 - GLSTAT SUBSTRING CHANGED TO REFERENCE CORRECT    */
/*                 SUBSTRING LENGTH                                 */
/*        S01267 - CREATED FOR MIS RELEASE 2.2 CHANGES              */
/*                                                                  */
/*********************************************************************/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
/**/
/*********** PGM                                                       S01189*/
             PGM        PARM(&CNAM &CSEQ)                            /*S01189*/
/**/
/*   Declare Variables    */
/**/
/*/COPY WNCPYSRC,SDC2438001                                          */
             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)               /*S01189*/
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5 0)               /*S01189*/
             DCL        VAR(&BUSY) TYPE(*CHAR) LEN(1) VALUE(' ')     /*S01189*/
/*********** DCL        VAR(&STAT) TYPE(*CHAR) LEN(3)                  S01189*/
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/*/COPY WNCPYSRC,SDC2438006                                          */
/**/
/*   Set off Switches                     */
/**/
             CHGJOB     SWS(00000000)
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
/**/
             SNDPGMMSG  MSG('SDC2438 - Spot Rates History +
                          Processing') TOMSGQ(MRUNQ) MSGTYPE(*INFO)
/**/
/****Check*if*position*54-56*in*dataara*GLSTAT*is*'NEW'****/          /*S01189*/
/**/
/************RTVDTAARA  DTAARA(GLSTAT (54 56)) RTNVAR(&STAT)       */ /*E23907*/
/************RTVDTAARA  DTAARA(GLSTAT (54 3)) RTNVAR(&STAT)  /*E23907* *S01189*/
/************IF         COND(&STAT *EQ 'NEW') THEN(DO)                *S01189*/
/*/COPY WNCPYSRC,SDC2438002                                          */
/**/                                                                 /*S01189*/
/*   Call PGM CB0160 , to find out the value of Busy              */ /*S01189*/
/**/                                                                 /*S01189*/
             CALL       PGM(CB0160) PARM(&CNAM &CSEQ &BUSY)          /*S01189*/
/**/                                                                 /*S01189*/
/**/                                                                 /*S01189*/
/*   If Busy is 'Y', which is equal to the value of the restart  */  /*S00189*/
/*   indicator.                                                  */  /*S01189*/
/**/                                                                 /*S01189*/
             IF         COND(&BUSY *EQ 'Y') THEN(DO)                 /*S01189*/
 
/**/
/*   Clear Spot History files  SDCUHSPD and SDCUHSPA */
/*   Copy XSDCUHSPD and XSDCUHSPA (security copies) to */
/*   SDCUHSPD and SDCUHSPA respectively */
/**/
             CLRPFM     FILE(SDCUHSPD)
             MONMSG     MSGID(CPF0000)
             CPYF       FROMFILE(XSDCUHSPD) TOFILE(SDCUHSPD) +
                          MBROPT(*REPLACE)
             MONMSG     MSGID(CPF2817)
/**/
             CLRPFM     FILE(SDCUHSPA)
             MONMSG     MSGID(CPF0000)
             CPYF       FROMFILE(XSDCUHSPA) TOFILE(SDCUHSPA) +
                          MBROPT(*REPLACE)
             MONMSG     MSGID(CPF2817)
/*/COPY WNCPYSRC,SDC2438003                                          */
/**/
/****Change*Positions*54-56*in*GLSTAT*to*'OLD'*******/                /*S01189*/
/**/
/************CHGDTAARA  DTAARA(GLSTAT (54 56)) VALUE(OLD)          */ /*E23907*/
/*********** CHGDTAARA  DTAARA(GLSTAT (54 3)) VALUE(OLD)      *E23907* *S01189*/
/**/
             ENDDO
/**/
/*        Create Security copies of Updated files */
/**/
 
             ELSE       CMD(DO)                                       /*S01189*/
             CLRPFM     FILE(XSDCUHSPD)
             MONMSG     MSGID(CPF0000)
             CPYF       FROMFILE(SDCUHSPD) TOFILE(XSDCUHSPD) +
                          MBROPT(*REPLACE)
             MONMSG     MSGID(CPF2817)
/**/
/*   Else Create Security copies of Updated files */
/**/
             CLRPFM     FILE(XSDCUHSPA)
             MONMSG     MSGID(CPF0000)
             CPYF       FROMFILE(SDCUHSPA) TOFILE(XSDCUHSPA) +
                          MBROPT(*REPLACE)
             MONMSG     MSGID(CPF2817)
/*/COPY WNCPYSRC,SDC2438004                                          */
/**/
/****Change*Positions*54-56*in*GLSTAT*to*'NEW'*******/
/**/
/************CHGDTAARA  DTAARA(GLSTAT (54 56)) VALUE(NEW)          */ /*E23907*/
/************CHGDTAARA  DTAARA(GLSTAT (54 3)) VALUE(NEW)      *E23907* *S01189*/
/*   Call PGM CB0150 with parameters 'Component Name',   */           /*S00189*/
/*   'Component Seq. No.' and Busy = 'Y'.  */                        /*S01189*/
/**/                                                                 /*S01189*/
/**/                                                                 /*S01189*/
             CALL       PGM(CB0150) PARM(&CNAM &CSEQ 'Y')            /*S01189*/
/**/                                                                 /*S01189*/
             ENDDO                                                   /*S01189*/
/**/
/*   Call RPG PGM SD2438    */
/**/
             CALL       PGM(SD2438)
/**/
/*   If Switches 7 and 8 are on,                    */
/*   Retrieve Error Narrative from LDA and send a   */
/*   MEM0001 message from the message File MIDAS to */
/*   Message Queues MOPERQ and MRUNQ.               */
/**/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/**/
/*********** RTVDTAARA  DTAARA(LDA (134 44)) RTNVAR(&MEM)            /*S01189*/
             RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)            /*S01189*/
/**/
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOMSGQ(MOPERQ MRUNQ) MSGTYPE(*INFO)
             MONMSG     MSGID(CPF2469)
/**/
             ENDDO
/**/
/*   If Switches 7 and 8 are off */
/**/
             ELSE       CMD(DO)
/**/
/****Change*Position*54-56*in*GLSTAT*to*'OLD'***************/        /*S01189*/
/****Clear*Security*copies*XSDCUHSPD*and*XSDCUHSPA********/          /*S01189*/
/**/
/************CHGDTAARA  DTAARA(GLSTAT (54 56)) VALUE(OLD)          */ /*E23907*/
/**********  CHGDTAARA  DTAARA(GLSTAT (54 3)) VALUE(OLD)     *E23907*  *S01189*/
/**/
/**/                                                                  /*S01189*/
/*   Call PGM CB0150 with parameters 'Component Name',   */           /*S01189*/
/*   'Component Seq. No.' and Busy = 'N'.                */           /*S01189*/
/*   Clear Security copies XSDCUHSPD and XSDCUHSPA       */           /*S01189*/
/**/                                                                  /*S01189*/
             CALL       PGM(CB0150) PARM(&CNAM &CSEQ 'N')             /*S01189*/
/**/                                                                  /*S01189*/
             CLRPFM     FILE(XSDCUHSPD)
             CLRPFM     FILE(XSDCUHSPA)
/*/COPY WNCPYSRC,SDC2438005                                          */
             ENDDO
/**/
             ENDPGM
