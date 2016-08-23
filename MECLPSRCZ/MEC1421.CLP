/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas ME BIC Plus version reader')                    */
/*********************************************************************/
/*                                                                   */
/*       Midas - Message Management                                  */
/*                                                                   */
/*       MEC1421  -  BIC version reader                              */
/*                                                                   */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.03 ---------------------------------------------------*/
/*       LAST AMEND NO. CFT007             DATE 08NOV99              */
/*       PREV AMEND NO. Xnnnnn             DATE ddmmmyy              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CFT007 - BIC Database Plus Integration                      */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&REL_DAT)
 
             DCL        VAR(&REL_DAT) TYPE(*CHAR) LEN(8)
/* Copyright statement                                               */
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
 /* ME BIC Plus revision date                                        */
             DCLF       FILE(METICVPD) RCDFMT(@TICVPD)
 
 
/* Global Monitor Message                                            */
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) +
                           EXEC(GOTO ENDCLPGM)
 
 
/* Retrieve the release date                                         */
             RCVF       RCDFMT(@TICVPD)
             MONMSG     MSGID(CPF0864)
             CHGVAR     VAR(&REL_DAT) VALUE(&BVRDAT)
 
 ENDCLPGM:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
 
             ENDPGM
