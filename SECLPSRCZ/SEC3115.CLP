/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SE EXTEL Cancellation')                         */
/********************************************************************/
/*                                                                  */
/*         Midas     - Securities Trading Module                */
/*                                                                  */
/*       SEC3115  -  EXTEL CANCELLATION                             */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. S01117            DATE  11JAN91             */
/*                                                                  */
/*------------------------------------------------------------------*/
/*                                                                  */
/*       S01117 - MULTIBRANCHING                                    */
/*                                                                  */
/*                                                                  */
/********************************************************************/
 
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/**/                                                                  /*S01117*/
      DCL    &TWIN     *CHAR      1          /* Tape/Wire Indicator           */
      DCL    &JNAM     *CHAR     10          /* Job name                      */
      DCL    &JUSR     *CHAR     10          /* Job user                      */
      DCL    &JNOM     *CHAR      6          /* Job number                    */
      DCL    &STNR     *CHAR     30          /* Status narr                   */
      DCL    &TRSN     *CHAR     30          /* Termination reason            */
      DCL    &RMSG     *CHAR    132          /* Reply message                 */
 
 
  SNDUSRMSG  MSG('EXTEL Cancellation') MSGTYPE(*INFO) TOMSGQ(MOPERQ)
 
/*---------------------------------------------------------------------*/
 
/*  Check if wire or tape processing to cancel                         */
 
   RTVDTAARA  DTAARA(EXSTAT (10 1)) RTNVAR(&TWIN)
 
/*---------------------------------------------------------------------*/
 
/*  Process if tape                                                    */
 
  IF    COND(&TWIN *EQ 'T')      THEN(DO)                    /*  B1  */
 
/*  Send message to end if option not required                         */
 
  SNDUSRMSG  MSG('Information will be reset to before status. +
                  Do you want to continue? Y/N')              +
                  VALUES(Y N) DFT(N) TOMSGQ(*EXT) MSGRPY(&RMSG)
 
/*  If yes continue, if no end                                         */
 
         IF    COND(&RMSG *EQ 'Y')         THEN(GOTO RESET)
         ELSE  IF    COND(&RMSG *EQ 'N')   THEN(GOTO ENDPGM)
 
  ENDDO                                                      /*  E1  */
 
/*---------------------------------------------------------------------*/
 
/*  Process if wire                                                    */
 
  IF    COND(&TWIN *EQ 'W')      THEN(DO)                    /*  B1  */
 
/*  Send message to end if option not required                         */
 
  SNDUSRMSG  MSG('Wire reception & updates will be cancelled. +
                  Do you want to continue? Y/N')              +
                  VALUES(Y N) DFT(N) TOMSGQ(*EXT) MSGRPY(&RMSG)
 
/*  If yes continue, if no end                                         */
 
         IF    COND(&RMSG *EQ 'N')      THEN(GOTO ENDPGM)    /* B&E2 */
 
  ENDDO                                                      /*  E1  */
 
/*---------------------------------------------------------------------*/
 
/*  Set data area EXSTAT to be picked up by Monitor                    */
 
         CHGVAR     &STNR ('JOB CANCELING                 ')
         CHGDTAARA  DTAARA(EXSTAT (108 30))  VALUE(&STNR)
 
/*  Set flag so EXTEL updates are cancelled                            */
 
         CHGDTAARA  DTAARA(EXSTAT (146 1))  VALUE('E')
 
/*  Find job information for transmission program                      */
 
        RTVDTAARA  DTAARA(EXSTAT (38 10)) RTNVAR(&JNAM)
        RTVDTAARA  DTAARA(EXSTAT (48 10)) RTNVAR(&JUSR)
        RTVDTAARA  DTAARA(EXSTAT (58 6))  RTNVAR(&JNOM)
 
/*  Cancel transmission program                                        +
    Monitor if already canceling or cancelled                          */
 
        ENDJOB     JOB(&JNOM/&JUSR/&JNAM)
        MONMSG     MSGID(CPF1360 CPF1361 CPF1362 CPF1363)
 
/*  Delay reset of data area EXSTAT so Monitor still displayed         +
     and loop in SEC3104 (updates) times out                           */
 
         DLYJOB     DLY(60)
 
/*---------------------------------------------------------------------*/
 
/*  Reset data area EXSTAT                                             */
 
 RESET:  CHGDTAARA  DTAARA(EXSTAT (76 1))   VALUE(F)
         CHGDTAARA  DTAARA(EXSTAT (77 1))   VALUE(N)
         CHGDTAARA  DTAARA(EXSTAT (146 1))  VALUE(N)
         CHGVAR     &TRSN ('                              ')
         CHGDTAARA  DTAARA(EXSTAT (78 30))  VALUE(&TRSN)
         CHGVAR     &STNR ('                              ')
         CHGDTAARA  DTAARA(EXSTAT (108 30))  VALUE(&STNR)
 
/*---------------------------------------------------------------------*/
 
 
/*ENDPGM:****ENDPGM                                                  * *S01117*/
ENDPGM:      CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
            ENDPGM                                                    /*S01117*/
 
