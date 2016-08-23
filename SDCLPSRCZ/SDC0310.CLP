/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SD Check job switches U7 & U8')                 */
/********************************************************************/
/*                                                                  */
/*    Midas STANDING DATA MODULE                                */
/*                                                                  */
/*****SDC0310***CL*PROGRAM TO CHECK JOB SWS U7 U8  (SD0310)         *   S01117*/
/*    SDC0310 - CL PROGRAM TO CHECK JOB SWS U7 U8(CALLED BY SD0541X)*   S01117*/
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*    LAST AMEND NO E25990                DATE 04JUL91              */
/*    PREV AMEND NO S01117                DATE 30APR90              */
/*                                                                  */
/*------------------------------------------------------------------*/
/*    E25990 - IF SWITCHES ARE 'OFF' AFTER A CALL WHEN SWITCHES WERE*/
/*             'ON', &RTNCDE AND &RTNCDE2 STILL CARRY THEIR OLD     */
/*             VALUES. THEY SHOULD BE INITIALISED FOR EACH CALL.    */
/*    S01117 - RELEASE 10 ENHANCEMENTS                              */
/*                                                                  */
/********************************************************************/
/*                                                                  */
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
 /*  PGM PARM(&RTNCDE)                                                 S01117 */
     PGM PARM(&RTNCDE &RTNCDE2)                                     /* S01117 */
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
     DCL VAR(&RTNCDE) TYPE(*CHAR) LEN(1)
     DCL VAR(&RTNCDE2) TYPE(*CHAR) LEN(1)                           /* S01117 */
 
     CHGVAR VAR(&RTNCDE) VALUE(' ')                                   /*E25990*/
     CHGVAR VAR(&RTNCDE2) VALUE(' ')                                  /*E25990*/
 
     IF COND(%SWITCH(XXXXXX1X)) THEN(DO)
     CHGVAR VAR(&RTNCDE) VALUE(1)
     ENDDO
     IF COND(%SWITCH(XXXXXXX1)) THEN(DO)
 /*  CHGVAR VAR(&RTNCDE) VALUE(1)                                      S01117 */
     CHGVAR VAR(&RTNCDE2) VALUE(1)                                  /* S01117 */
     ENDDO
 
     CHGJOB SWS(00000000)                                             /*E25990*/
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
     ENDPGM
