/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas LE Update Profitability Extract Files')         */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Customer Lending Module                     */
/*                                                                   */
/*       LERC425 - Update profitability extract files                */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/*                                                                   */
/*       Last Amend No. CLE075AJ           Date 06Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. Xnnnnn             DATE ddmmmyy              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CLE075AJ  - COB Restructure - LE COB Optimisation Phase 1   */
/*                 - Remove recovery process as this can be re-run   */
/*                   without causing update errors.                  */
/*       Xnnnnn -                                                    */
/*                                                                   */
/*********************************************************************/
 
             PGM        PARM(&CNAM &CSEQ)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
/*           DCLF       FILE(SDBANKPD)                       0111*/
 
/* Declare the variables for rerun checking */
 
             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5 0)
/**********  DCL        VAR(&STAT) TYPE(*CHAR) LEN(1) VALUE(' ')   */                   /*CLE075AJ*/
 
/* Read PF/SDBANKPD for Midas Run Date (DDMMMYY format) and */
/* update DTAARA/LERSTS for use by Profitability Reports    */
 
/*           RCVF       RCDFMT(SDBANKD0)                        0111*/
/*           CHGDTAARA  DTAARA(LERSTS (122 7)) VALUE(&BJMRDT)   0111*/
 
             SNDPGMMSG  MSG('Update Profitability Extract Files') +
                        TOMSGQ(MRUNQ)
 
/**Check*the*current*status*of*this*component**//*******************/                   /*CLE075AJ*/
 
/**********  CALL       PGM(CB0160) PARM(&CNAM &CSEQ &STAT)        */                   /*CLE075AJ*/
 
/**********  IF         COND(&STAT *EQ 'Y') THEN(DO)               */                   /*CLE075AJ*/
 
/* Copy back Profitability Extract Security Files */
 
/**********  CPYF       FROMFILE(XLEPLND) TOFILE(LEPELND) +
                          MBROPT(*REPLACE)                         */                   /*CLE075AJ*/
/**********  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(LEPELND))                           */                   /*CLE075AJ*/
/**********  CPYF       FROMFILE(XLEPFCD) TOFILE(LEPEFCD) +
                          MBROPT(*REPLACE)                         */                   /*CLE075AJ*/
/**********  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(LEPEFCD))                           */                   /*CLE075AJ*/
/**********  CPYF       FROMFILE(XLEPRED) TOFILE(LEPERED) +
                          MBROPT(*REPLACE)                         */                   /*CLE075AJ*/
/**********  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(LEPERED))                           */                   /*CLE075AJ*/
/**********  CPYF       FROMFILE(XLEPGLD) TOFILE(LEPEGLD) +
                          MBROPT(*REPLACE)                         */                   /*CLE075AJ*/
/**********  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(LEPEGLD))                           */                   /*CLE075AJ*/
/**********  CPYF       FROMFILE(XLEPDFD) TOFILE(LEPEDFD) +
                          MBROPT(*REPLACE)                         */                   /*CLE075AJ*/
/**********  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(LEPEDFD))                           */                   /*CLE075AJ*/
 
/**********  ENDDO                                                 */                   /*CLE075AJ*/
 
/**********  ELSE       CMD(DO)                                    */                   /*CLE075AJ*/
 
/**Take*Security*Copy*of*Profitability*Extract*Files**//************/                   /*CLE075AJ*/
 
/**********  CPYF       FROMFILE(LEPELND) TOFILE(XLEPLND) +
                          MBROPT(*REPLACE)                         */                   /*CLE075AJ*/
/**********  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(XLEPLND))                           */                   /*CLE075AJ*/
/**********  CPYF       FROMFILE(LEPEFCD) TOFILE(XLEPFCD) +
                          MBROPT(*REPLACE)                         */                   /*CLE075AJ*/
/**********  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(XLEPFCD))                           */                   /*CLE075AJ*/
/**********  CPYF       FROMFILE(LEPERED) TOFILE(XLEPRED) +
                          MBROPT(*REPLACE)                         */                   /*CLE075AJ*/
/**********  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(XLEPRED))                           */                   /*CLE075AJ*/
/**********  CPYF       FROMFILE(LEPEGLD) TOFILE(XLEPGLD) +
                          MBROPT(*REPLACE)                         */                   /*CLE075AJ*/
/**********  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(XLEPGLD))                           */                   /*CLE075AJ*/
/**********  CPYF       FROMFILE(LEPEDFD) TOFILE(XLEPDFD) +
                          MBROPT(*REPLACE)                         */                   /*CLE075AJ*/
/**********  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(XLEPDFD))                           */                   /*CLE075AJ*/
 
/**Set*the*status*to*failed*(&STAT*=*Y)*in*case*the*program*fails***/                   /*CLE075AJ*/
 
/**********  CHGVAR     VAR(&STAT) VALUE('Y')                      */                   /*CLE075AJ*/
/**********  CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STAT)        */                   /*CLE075AJ*/
 
/**********  ENDDO                                                 */                   /*CLE075AJ*/
 
/* Call profitability extract file update program */
 
             CALL       PGM(LER425)
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
 
             SNDPGMMSG  MSG('Job terminated, database in error. +
                          Contact Systems Department.') +
                          TOMSGQ(MOPERQ MRUNQ)
             ENDDO
/**********  ELSE       CMD(DO)                                    */                   /*CLE075AJ*/
 
/**If*the*component*has*completed*successfully*reset*the*status*field**/                /*CLE075AJ*/
 
/**********  CHGVAR     VAR(&STAT) VALUE('N')                      */                   /*CLE075AJ*/
/**********  CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STAT)        */                   /*CLE075AJ*/
 
/**********  ENDDO                                                 */                   /*CLE075AJ*/
 
END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
