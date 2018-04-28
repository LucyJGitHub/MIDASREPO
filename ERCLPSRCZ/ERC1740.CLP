/********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas ER - Save Parameters Maintenance')              */
/********************************************************************/
/*                                                                  */
/*       MIDAS/ABS STANDING DATA MODULE                             */
/*                                                                  */
/*       ERC1740- SAVE PARAMETERS MAINTENANCE                       */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2005           */
/*       NEW PROGRAM CREATED 50314 ADI    DATE 28MAY93              */
/*                                                                  */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. CER001             Date 25Apr05              */
/*       Prev Amend No. ULX004             Date 29Oct97              */
/*                                                                  */
/*------------------------------------------------------------------*/
/*       CER001 - LUX Upgrade to MidasPlus                           */
/*      ULX004 - CAPITAL ADEQUACY, AND ALLOWS TO RUN IML TOO.       */
/*                                                                  */
/********************************************************************/
             PGM
/**/
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(44)
             DCL        VAR(&LDA) TYPE(*CHAR) LEN(256)
/**********  DCL        VAR(&SID) TYPE(*CHAR) LEN(2)                      */       /*ULX004 CER001*/
/**/
/*   GLOBAL MONITOR MESSAGE                                         */
/**/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO ABNOR)
/**/
             SNDPGMMSG  MSG('Save Parameters Maintenance') TOMSGQ(MRUNQ)
/**/
             CHGJOB     SWS(00000000)
/**********  RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&SID)                 */       /*ULX004 CER001*/
/**********  ADDLIBLE (&SID *CAT 'CADLIB')                                */       /*ULX004 CER001*/
/**********  MONMSG CPF2103                                               */       /*ULX004 CER001*/
             OVRDBF     FILE(TABLE) TOFILE(TABICD)
/**/
/*   CALL SAVE PARAMETERS MAINTAENCE                                 */
/**/
             CALL  ER1740
/**/
             IF    COND(%SWITCH(XXXXXX11)) THEN(GOTO DBERR)
/**/
             GOTO  END
/**/
/*   DATABASE ERROR PROCESSING                                       */
/**/
DBERR:       RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)
             CHGVAR     VAR(&MEM) VALUE(%SST(&LDA 134 44))
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) +
             MSGDTA(&MEM) TOMSGQ(MOPERQ MRUNQ) +
             TOPGMQ(*EXT)
/**/
             GOTO  END
/**/
ABNOR:       SNDPGMMSG  MSG('PROGRAM - Save Parameters Maintenance - +
                        ENDED ABNORMALLY') +
                        TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
END: /*******ENDPGM                                                     ULX004*/
/**********  RMVLIBLE (&SID *CAT 'CADLIB')                                */       /*ULX004 CER001*/
/**********  MONMSG CPF2104                                               */       /*ULX004 CER001*/
             ENDPGM                                                   /*ULX004*/
