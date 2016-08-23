/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas Trader Support Enviroment setting.')            */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Trader Support module.                      */
/*                                                                   */
/*       TSC6690 - Set the Trader Support enviroment.                */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. XXXXXX           DATE XXXXXXX                */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*                                                                   */
/*********************************************************************/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&USRID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&JOB) TYPE(*CHAR) LEN(10)
/**/
             MONMSG     MSGID(RPG0000 CPF0000 MCH0000) +
                        EXEC(GOTO CMDLBL(THEEND))
/**/
             RTVJOBA    JOB(&JOB) USER(&USRID)
             MONMSG     MSGID(CPF0000)
/**/
/* Change the message queue for this user to *notify */
             CHGMSGQ    MSGQ(&USRID) DLVRY(*NOTIFY) PGM(*SAME)
             MONMSG     MSGID(CPF2451)
 
/* Change the message queue for this JOB to *hold */
             CHGMSGQ    MSGQ(&JOB) DLVRY(*HOLD) PGM(*SAME)
             MONMSG     MSGID(CPF2451)
 
/**/
/*  Change the job to hold all messages for Trader Support user */
             CHGJOB     LOG(4 0 *SECLVL) LOGCLPGM(*YES) +
                          INQMSGRPY(*DFT) BRKMSG(*NOTIFY) STSMSG(*NONE)
             MONMSG     MSGID(CPF0000)
/**/
/*  Change the job queue for Trader Support user queue */
             CHGMSGQ    MSGQ(MOPERQ) DLVRY(*HOLD)
             MONMSG     MSGID(CPF0000)
/**/
/**/
/**/
THEEND:      CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
