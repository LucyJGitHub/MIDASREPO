/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas RE Copy SoM Balances for RE Activity Extract')  */
/*********************************************************************/
/*                                                                   */
/*       Midas - Retail Module                                       */
/*                                                                   */
/*       REC3680A - Copy SoM Balances for RE Activity Extract        */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2008           */
/*                                                                   */
/*       Last Amend No. CRE083BH           Date 06Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/*       Prev Amend No. CCB016  *CREATE    Date 28May08              */
/*      Midas Plus 1.4 Base -----------------------------------------*/
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CRE083BH - COB Restructure - RE COB Optimisation Phase 1    */
/*       CCB016 - Allow REC3860 to run during CoB of first day of    */
/*                the month followed by a non-working day.           */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2008')
             DCL        VAR(&ERROR) TYPE(*CHAR) LEN(1)                                  /*CRE083BH*/
 
             SNDPGMMSG  MSG('Copy SoM Balances for RE Activity +
                          Extract') TOMSGQ(MRUNQ)
 
/**Copy*GLACBTPD*to*REACBMPP******************************************        */        /*CRE083BH*/
 
/**********  CPYF       FROMFILE(GLACBTPD) TOFILE(REACBMPP) +
                          MBROPT(*REPLACE) FMTOPT(*MAP *DROP)        */                 /*CRE083BH*/
/**********  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                        FILE(REACBMPP))                              */                 /*CRE083BH*/
 
/* Call RE003860 to copy GLACBTPD to REACBMPP                        */                 /*CRE083BH*/
             CHGVAR     VAR(&ERROR) VALUE('N')                                          /*CRE083BH*/
             CLRPFM     FILE(REACBMPP)                                                  /*CRE083BH*/
             CALL       PGM(RE003860) PARM(&ERROR)                                      /*CRE083BH*/
                                                                                        /*CRE083BH*/
             IF         COND(&ERROR *EQ 'Y') THEN(DO)                                   /*CRE083BH*/
                CLRPFM     FILE(REACBMPP)                                               /*CRE083BH*/
             ENDDO                                                                      /*CRE083BH*/
                                                                                        /*CRE083BH*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
ENDPGM:      ENDPGM
