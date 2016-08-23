/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas GL Account enquiry')                            */
/*********************************************************************/
/*                                                                   */
/*       Midas - General Ledger Module                               */
/*                                                                   */
/*       GLC002000 - Account Enquiry                                 */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2004           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*       Last Amend No.  BG18886           Date 29May08              */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CGP004  *CREATE    Date 02Mar04              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       BG18886 - Amend non-standard codes.                         */
/*       CGP004 - Audit Reporting                                    */
/*                                                                   */
/*********************************************************************/
             PGM
 
             DCL        VAR(&RTCD)  TYPE(*CHAR) LEN( 7)
             DCL        VAR(&ERMS)  TYPE(*CHAR) LEN(50)
 
             DCL        VAR(&BRCA)  TYPE(*CHAR) LEN( 3)
             DCL        VAR(&ENQ1)  TYPE(*CHAR) LEN( 1)
             DCL        VAR(&ENQ2)  TYPE(*CHAR) LEN( 1)
             DCL        VAR(&ENQ3)  TYPE(*CHAR) LEN( 1)
             DCL        VAR(&ENQ4)  TYPE(*CHAR) LEN( 1)
             DCL        VAR(&RET3)  TYPE(*CHAR) LEN( 1)
             DCL        VAR(&OMCL)  TYPE(*CHAR) LEN( 1)
             DCL        VAR(&ACMN)  TYPE(*CHAR) LEN( 2)
             DCL        VAR(&INKC)  TYPE(*CHAR) LEN( 1)
             DCL        VAR(&INKL)  TYPE(*CHAR) LEN( 1)
 
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2004')
 
/** GLOBAL MONITOR MESSAGE */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CHGJOB     SWS(00000000)
 
/* Prompt */
 LOOP:       CALL       PGM(GL002000) PARM(&RTCD &ERMS &BRCA &ENQ1 +
                          &ENQ2 &ENQ3 &ENQ4 &RET3 &OMCL &ACMN &INKC +
                          &INKL)
 
/* ERROR */
/**********  IF         COND(&RTCD *= ' ') THEN(GOTO CMDLBL(ABNOR))                   */ /*BG18886*/
             IF         COND(&RTCD *NE ' ') THEN(GOTO CMDLBL(ABNOR))                     /*BG18886*/
/* END */
             IF         COND(&INKC = '1') THEN(GOTO CMDLBL(END))
/* END */
             IF         COND(&INKL = '1') THEN(GOTO CMDLBL(END))
 
/**  ENQUIRY 1 ********************************************************/
 
/**********  IF         COND(&ENQ1 *= ' ') THEN(DO)                                   */ /*BG18886*/
             IF         COND(&ENQ1 *NE ' ') THEN(DO)                                     /*BG18886*/
             CALL       PGM(GL002001) PARM(&RTCD &ERMS &BRCA &OMCL +
                          &ACMN &INKC &INKL)
/* END */
             IF         COND(&INKC = '1') THEN(GOTO CMDLBL(END))
             ENDDO
 
/**  ENQUIRY 2 ********************************************************/
 
/**********  IF         COND(&ENQ2 *= ' ') THEN(DO)                                   */ /*BG18886*/
             IF         COND(&ENQ2 *NE ' ') THEN(DO)                                     /*BG18886*/
             CALL       PGM(GL002002) PARM(&RTCD &ERMS &BRCA &OMCL +
                          &ACMN &INKC &INKL)
/* END */
             IF         COND(&INKC = '1') THEN(GOTO CMDLBL(END))
             ENDDO
 
/**  ENQUIRY 3 ********************************************************/
 
/**********  IF         COND(&ENQ3 *= ' ') THEN(DO)                                   */ /*BG18886*/
             IF         COND(&ENQ3 *NE ' ') THEN(DO)                                     /*BG18886*/
/**********  IF         COND(&RET3 *= ' ') THEN(OVRDBF ACCBR RELIVE)                  */ /*BG18886*/
             IF         COND(&RET3 *NE ' ') THEN(OVRDBF ACCBR RELIVE)                    /*BG18886*/
             CALL       PGM(GL002003) PARM(&RTCD &ERMS &BRCA &OMCL +
                          &ACMN &INKC &INKL)
             DLTOVR     FILE(ACCBR)
             MONMSG CPF0000
/* END */
             IF         COND(&INKC = '1') THEN(GOTO CMDLBL(END))
             ENDDO
 
/**  ENQUIRY 4 ********************************************************/
 
/**********  IF         COND(&ENQ4 *= ' ') THEN(DO)                                   */ /*BG18886*/
             IF         COND(&ENQ4 *NE ' ') THEN(DO)                                     /*BG18886*/
             CALL       PGM(GL002004) PARM(&RTCD &ERMS &BRCA &OMCL +
                          &ACMN &INKC &INKL)
/* END */
             IF         COND(&INKC = '1') THEN(GOTO CMDLBL(END))
             ENDDO
 
             GOTO       CMDLBL(LOOP)
 
 
/** ABNORMAL ERROR PROCESSING                                      */
 ABNOR:      SNDPGMMSG  MSG('PROGRAM GLC002000 ENDED ABNORMALLY') +
                          TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGJOB     SWS(XXXXXX11)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
