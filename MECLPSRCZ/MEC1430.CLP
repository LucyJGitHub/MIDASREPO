/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas ME BIC Plus loader')                            */
/*********************************************************************/
/*                                                                   */
/*       Midas - Message Management                                  */
/*                                                                   */
/*       MEC1430  -  BIC Plus search index creation                  */
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
             PGM
 
/* Copyright statement                                               */
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
/* Global Monitor Message                                            */
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) +
                           EXEC(GOTO ENDCLPGM)
 
             CLRPFM     FILE(MEBICIPD)
 
/* Call the BIC Plus search index creation program                  */
             CALL       PGM(ME1430) PARM('       ')
 
 ENDCLPGM:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
             ENDPGM
