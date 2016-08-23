/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas ABS ER Guarantees/Collateral/Provisions Main')  */
/*********************************************************************/
/*                                                                   */
/*       Midas¦ABS - ER Module                                       */
/*                                                                   */
/*       ERC0910 - Guarantees/Collateral/Provision Maintenance       */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2005           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. CER001             Date 25Apr05              */
/*       Prev Amend No. ULX004             Date 21Feb97              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       CER001 - LUX Upgrade to MidasPlus                           */
/*       ULX004 - Capital Adequacy                                   */
/*                                                                   */
/*********************************************************************/
             PGM
 
             DCL        VAR(&ACTCPY) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2005')
/**********  DCL        VAR(&E1PARM) TYPE(*CHAR) LEN(89)          */               /*ULX004 CER001*/
             DCL        VAR(&E1PARM) TYPE(*CHAR) LEN(104)                                 /*CER001*/
/* Global Monitor Message */
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CHGJOB     SWS(00000000)
 
/* Call Maintenancce pgm  */
/**          CALL       PGM(ER0910)                                   ULX004 */
             CHGVAR     VAR(&E1PARM) VALUE(' ')                    /* ULX004 */
             CALL       PGM(ERL910) PARM(&E1PARM)                  /* ULX004 */
 
/*  Program Terminated Abnormally */
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ABNOR))
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)           /* ULX004 */
                COMMIT                                             /* ULX004 */
             ENDDO                                                 /* ULX004 */
 
             GOTO       CMDLBL(END)
 
/*  Error in pgm  */
 ABNOR:      DMPCLPGM
             ROLLBACK
             SNDMSG     MSG('ERC0910 - +
                          Guarantees/Collateral/Provision +
                          Maintenance Terminated Abnormally') +
                          TOMSGQ(MOPERQ)
 
 END:        CHGVAR     VAR(&ACTCPY) VALUE('(c) Misys International +
                          Banking Systems Ltd. 2005')
             ENDPGM
