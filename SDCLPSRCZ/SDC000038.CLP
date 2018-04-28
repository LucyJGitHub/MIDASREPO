/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SD Initialisation program for CDL031')          */
/*********************************************************************/
/*                                                                   */
/*       Midas - Standing Data Module                                */
/*                                                                   */
/*       SDC000038 - Initialisation program for CDL031               */                  /*BUG6730*/
/********SDC000028 - Initialisation program for CDL031****************/                  /*BUG6730*/
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2004           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. BUG6730            Date 04May05              */
/*       Prev Amend No. CDL031  *CREATE    Date 07Dec04              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       BUG6730 - Renamed SDC000028 into SDC000038                  */
/*       CDL031 - Effective Date on Extended SSI                     */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&RTCDE &PMODE)
 
             DCL        VAR(&PMODE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RTCDE) TYPE(*CHAR) LEN(7)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2004')
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CHGJOB     SWS(XXXXXX00)
 
/* Mode 1 - First call */
 
             IF         COND(&PMODE *EQ '1') THEN(DO)
             CALL       PGM(SD000038) PARM('Y')                                          /*BUG6730*/
/**********  CALL       PGM(SD000028) PARM('Y') */                                       /*BUG6730*/
             ENDDO
 
/* Mode 2 - Second call */
 
             IF         COND(&PMODE *EQ '2') THEN(DO)
             CALL       PGM(SD000038) PARM('Y')                                          /*BUG6730*/
/**********  CALL       PGM(SD000028) PARM('Y') */                                       /*BUG6730*/
             ENDDO
 
/* Mode 3 - Deletion */
 
             IF         COND(&PMODE *EQ '3') THEN(DO)
             CALL       PGM(SD000038) PARM('N')                                          /*BUG6730*/
/**********  CALL       PGM(SD000028) PARM('N') */                                       /*BUG6730*/
             ENDDO
 
/* Database error processing */
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ABNOR))
 
             GOTO       CMDLBL(END)
 
/* Abnormal termination */
 
ABNOR:
             CHGJOB     SWS(XXXXXX11)
             ROLLBACK
             CHGVAR     VAR(&RTCDE) VALUE('*ERROR')
 
/* Send the error message */
 
/**********  SNDPGMMSG  MSG('Program SDC000028 ended abnormally') + */                   /*BUG6730*/
/**********               TOMSGQ(MOPERQ) */                                              /*BUG6730*/
             SNDPGMMSG  MSG('Program SDC000038 ended abnormally') +
                          TOMSGQ(MOPERQ)                                                 /*BUG6730*/
             MONMSG     MSGID(CPF0000 MCH0000)
 
/* End program */
 
END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
