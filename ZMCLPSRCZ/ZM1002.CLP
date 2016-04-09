/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas Clear program message queue')                   */
/*********************************************************************/
/*                                                                   */
/*    Midas - STANDING DATA                                  */
/*                                                                   */
/*    ZM1002 - SEND PROGRAM MESSAGE FOR PROGRAM WORKSTATION FILES    */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*    LAST AMEND NO. XXXXXX           DATE   XX/XX/XX                */
/*                                                                   */
/********************************************************************/
             PGM
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
             RMVMSG     PGMQ(*PRV) CLEAR(*ALL)
 
 GOTO END
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 END:        ENDPGM
