/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas GL IBAN installation program')                  */
/*********************************************************************/
/*                                                                   */
/*       Midas - General Ledger Module                               */
/*                                                                   */
/*       GLC3280 - IBAN Initialisation Program                       */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. CCB020             Date 06Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      CER001             Date 25Apr05              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.03 ---------------------------------------------------*/
/*                      CCB009             Date 01Jun00              */
/* Midas DBA 3.02 ---------------------------------------------------*/
/*                      CFT004 *CREATE     Date 10Aug99              */
/* Midas DBA 3.00---------------- Base ------------------------------*/
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CCB020 - COB Restructure - Secondary COB Infrastracture     */
/*       CER001 - LUX Upgrade to MidasPlus                           */
/*       CCB009 - Journal files throughout close of business         */
/*       CFT004 - New program for IBAN initialisation.               */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&RTNCDE &MODE)
 
 
             DCL        VAR(&RTNCDE) TYPE(*CHAR) LEN(7)
             DCL        VAR(&MODE)   TYPE(*CHAR) LEN(1)
/**********  DCL        VAR(&MPHAS)  TYPE(*CHAR) LEN(1)                                */ /*CCB020*/
             DCL        VAR(&PREFIX) TYPE(*CHAR) LEN(2)
             DCL        VAR(&JLIB)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&CMTCTL) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**********                                                                    /*CCB009*/ /*CCB020*/
/**Declare*variable CCB009 - flag for switchable feature                       /*CCB009*/ /*CCB020*/
/**********                                                                    /*CCB009*/ /*CCB020*/
/**********  DCL        VAR(&CCB009) TYPE(*CHAR) LEN(7)                        /*CCB009*/ /*CCB020*/
             DCL        VAR(&AOFMT) TYPE(*CHAR) LEN(200)              /*CCB009*/
 
                                                                                          /*CER001*/
/** Declare variable ULX053 -  flag for IBANLUX switchable feature */                     /*CER001*/
                                                                                          /*CER001*/
             DCL        VAR(&ULX053) TYPE(*CHAR) LEN(1)                                   /*CER001*/
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)                                     /*CER001*/
                                                                                          /*CER001*/
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
/**********                                                                    /*CCB009*/ /*CCB020*/
/***Check*for Switchable feature CCB009.                                       /*CCB009*/ /*CCB020*/
/**********                                                                    /*CCB009*/ /*CCB020*/
/**********  CALL       PGM(AOSARDR0) PARM(&CCB009 '*VERIFY' +                            /*CCB020*/
/**********               'CCB009' &AOFMT)                                     /*CCB009*/ /*CCB020*/
 
/** Check for Switchable feature ULX053 */                                                /*CER001*/
                                                                                          /*CER001*/
             CALL       PGM(AOSARDR0) PARM(&RTCD '*VERIFY' +
                          'ULX053' &AOFMT)                                                /*CER001*/
             IF         COND(&RTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&ULX053) VALUE('Y'))                                        /*CER001*/
                                                                                          /*CER001*/
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256)
             MONMSG     MSGID(CPF0000)
 
 
 /* Check what mode in */
             IF         COND((&MODE *EQ '1') *OR (&MODE *EQ '2')) +
                          THEN(DO)
 /**Check*which*phase*in*************************************************              */ /*CCB020*/
 /********** RTVDTAARA  DTAARA(MPHAS) RTNVAR(&MPHAS)                                      /*CCB020*/
 /**If*in*Close*of*Business**********************************************                 /*CCB020*/
 /********** IF         COND(&MPHAS *EQ 'D') THEN(DO)                                     /*CCB020*/
 
/* Retrieve the system prefix */
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&PREFIX)
 
/* Build the name of the target JLIB */
             CHGVAR     VAR(&JLIB) VALUE(&PREFIX *CAT 'JLIB')
 
/**********                                                                    /*CCB009*/ /*CCB020*/
/**If*Feature CCB009 is NOT 'on' (close of business journaling),               /*CCB009*/ /*CCB020*/
/**********                                                                    /*CCB009*/ /*CCB020*/
/**********  IF         COND(&CCB009 *NE '       ') THEN(DO)                   /*CCB009*/ /*CCB020*/
/* Setup journal environment and start journalling */
/**********  CRTJRNRCV  JRNRCV(&JLIB/JRGLC3280) TEXT('Journal +                           /*CCB020*/
/**********               receiver for installation of CFT004')                           /*CCB020*/
/**********                                                                               /*CCB020*/
/**********  CRTJRN     JRN(&JLIB/JGLC3280) JRNRCV(&JLIB/JRGLC3280) +                     /*CCB020*/
/**********               TEXT('CFT004 Installation temporary journal')                   /*CCB020*/
/**********                                                                    /*CER001*/ /*CCB020*/
/**********  IF         COND(&ULX053 *EQ 'Y') THEN(DO)                         /*CER001*/ /*CCB020*/
/**********  STRJRNPF   FILE(SDBRCHPD SDFCTLPA SDBANKPD SDFTFRPD +                        /*CCB020*/
/**********               SDCTRYPD ACCNTAB SDACODPD SDACX3PD) +                           /*CCB020*/
/**********               JRN(JGLC3280) IMAGES(*BOTH) +                                   /*CCB020*/
/**********               OMTJRNE(*OPNCLO)                                     /*CER001*/ /*CCB020*/
/**********  ENDDO                                                             /*CER001*/ /*CCB020*/
/**********  ELSE       CMD(DO)                                                /*CER001*/ /*CCB020*/
 
/**********  STRJRNPF   FILE(SDBRCHPD SDFCTLPA SDBANKPD SDFTFRPD +
                          SDCTRYPD ACCNTAB) JRN(JGLC3280) +
                          IMAGES(*BOTH) OMTJRNE(*OPNCLO)                               */ /*CCB020*/
/**********  ENDDO                                                              */ /*CER001 CCB020*/
/**********  ENDDO                                                             /*CCB009*/ /*CCB020*/
 
 
/* Start commitment control    */
 
             STRCMTCTL  LCKLVL(*CHG)
             MONMSG     MSGID(CPF8351) EXEC(CHGVAR VAR(&CMTCTL) +
                             VALUE('Y'))
             ENDDO
 
/* Call countries maintenance  */
             CALL       PGM(SD0005) PARM('SD0180M' 'SD0180D' 'M' +
                          'SD0181R')
 
/* Call branches maintenance   */
             CALL       PGM(SD0060D) PARM(' ' 'M')
 
/** Call account codes maintenance  */                                                    /*CER001*/
             IF         COND(&ULX053 *EQ 'Y') THEN(DO)                                    /*CER001*/
             CALL       PGM(SD0030D) PARM(' ' 'M')                                        /*CER001*/
             ENDDO                                                                        /*CER001*/
                                                                                          /*CER001*/
/* Call IBAN Installation      */
             CALL       PGM(GL3280) PARM(&RTNCDE)
 
 /**If*in*Close*of*Business**********************************************              */ /*CCB020*/
/**********  IF         COND(&MPHAS *EQ 'D') THEN(DO)                                  */ /*CCB020*/
/* Only end commitment control if started from this program */
             IF         COND(&CMTCTL *NE 'Y') THEN(ENDCMTCTL)
 
/**********                                                                    /*CCB009*/ /*CCB020*/
/* If Feature CCB009 is NOT 'on' (close of business journaling),               /*CCB009*/ /*CCB020*/
/**********                                                                    /*CCB009*/ /*CCB020*/
/**********  IF         COND(&CCB009 *NE '       ') THEN(DO)                   /*CCB009*/ /*CCB020*/
/* End Journalling  */
 
/**********  ENDJRNPF   FILE(SDBRCHPD)                                                    /*CCB020*/
/**********  MONMSG     MSGID(CPF0000)                                                    /*CCB020*/
 
/**********  ENDJRNPF   FILE(SDFCTLPA)                                                    /*CCB020*/
/**********  MONMSG     MSGID(CPF0000)                                                    /*CCB020*/
 
/**********  ENDJRNPF   FILE(SDBANKPD)                                                    /*CCB020*/
/**********  MONMSG     MSGID(CPF0000)                                                    /*CCB020*/
 
/**********  ENDJRNPF   FILE(SDFTFRPD)                                                    /*CCB020*/
/**********  MONMSG     MSGID(CPF0000)                                                    /*CCB020*/
 
/**********  ENDJRNPF   FILE(SDCTRYPD)                                                    /*CCB020*/
/**********  MONMSG     MSGID(CPF0000)                                                    /*CCB020*/
 
/**********  ENDJRNPF   FILE(ACCNTAB)                                                     /*CCB020*/
/**********  MONMSG     MSGID(CPF0000)                                                    /*CCB020*/
 
 /* Delete temporary journal  */
/**********  DLTJRN     JRN(JGLC3280)                                                     /*CCB020*/
/**********  MONMSG     MSGID(CPF0000)                                                    /*CCB020*/
 
/* Change job to automatically reply to the journal receiver not */
/* fully saved message.                                          */
 
/**********  CHGJOB     INQMSGRPY(*DFT)                                                   /*CCB020*/
 
/**********  DLTJRNRCV  JRNRCV(JRGLC3280)                                                 /*CCB020*/
/**********  MONMSG     MSGID(CPF0000)                                                    /*CCB020*/
 
/* Change job to reply required again */
 
/**********    CHGJOB     INQMSGRPY(*RQD)                                                 /*CCB020*/
/**********  ENDDO                                                             /*CCB009*/ /*CCB020*/
 
 
/**********  ENDDO                                                                     */ /*CCB020*/
/**********  ENDDO                                                                        /*CCB020*/
             GOTO       CMDLBL(END)
 
 ABNOR:
 
             CHGVAR     VAR(&RTNCDE) VALUE(FAIL)
             MONMSG     MSGID(CPF0000)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
 
             ENDPGM
