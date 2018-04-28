/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas TREASURY MANAGEMENT ENQUIRY CONTROL')           */
/********************************************************************/
/*                                                                  */
/*       Midas     - Treasury Management module                */
/*                                                                  */
/*       TMC0311 -  TREASURY MANAGEMENT ENQUIRY CONTROL.            */
/*                        (FORMALLY DL0311)                         */
/*                                                                  */
/*       Function: This program controls the process by which TM    */
/*       (I/C)     enquiries are called from Midas enquiries menu.  */
/*                                                                  */
/*       Called by: Main menu                                       */
/*                                                                  */
/*       Calls    : DL3100  - Treasury management controller        */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. S01117            DATE  08FEB91             */
/*       PREV AMEND NO. E19340            DATE  18JAN90             */
/*                                                                  */
/********************************************************************/
/*                                                                  */
/*       S01117  -  UPGRADED FOR RELEASE 10 TREASURY MANAGEMENT     */
/*                  NOTE: THIS PROGRAM CALLS DL3100 WHICH HAS NOT   */
/*                        BEEN RENAMED TO TM3100 AT PRESENT DUE TO  */
/*                        FRA/IRS BEING PRESENT.                    */
/*                                                                  */
/*       E19340  -  NEW PROGRAM CREATED FOR E19340                  */
/*                                                                  */
/********************************************************************/
/*                                                                    */
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&PRM01 &PRM02)
             DCL        &PRM01        TYPE(*CHAR)  LEN(6)
             DCL        &PRM02        TYPE(*CHAR)  LEN(6)
             DCL        &SWS          TYPE(*CHAR)  LEN(8)
             DCL        &JOB          TYPE(*CHAR)  LEN(10)
             DCL        &USER         TYPE(*CHAR)  LEN(10)
             DCL        &DATE         TYPE(*CHAR)  LEN(6)
             DCL        &MSG          TYPE(*CHAR)  LEN(75)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/**/
             RTVJOBA    JOB(&JOB)  USER(&USER)  DATE(&DATE)
             CHGJOB     SWS(00000000)
/**/
             IF         COND((&PRM01) *EQ ('DL3100')) THEN(CALL +
                          PGM(&PRM01) PARM(&PRM02))
             ELSE       CMD(CALL PGM(&PRM01))
 
/**/
             RTVJOBA    SWS(&SWS)
 /*                                                                 */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
             CHGVAR     VAR(&MSG) VALUE('Job Terminated - Database +
                          Error')
             SNDMSG     MSG(&MSG) TOMSGQ(&JOB)
             ENDDO
 /*                                                                 */
 ENDCLPGM:   CHGJOB     SWS(00000000)
             RETURN
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM    /* END CL PGM */
