/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas EM LIMITS MAINTENANCE AUDIT TRAIL')             */
/********************************************************************/
/*                                                                  */
/*              Midas EXPOSURE MANAGEMENT MODULE            */
/*                                                                  */
/*       EMC0601 - LIMITS AUDIT TRAIL                               */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. 228542             Date 05Aug04              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No  E40394             Date 21May92              */
/*                      E22940             Date 30May91              */
/*                                                                   */
/*********************************************************************/
/*       228542 - RGZPFM has changed at R5V3                         */
/*       E40394 - MONITOR FOR EMPTY FILE ON REORGANISATION          */
/*       E22940 - Drop deleted limits from file                     */
/*********************************************************************/
             PGM
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/**/
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(132) +
                        VALUE('Limits Maintenance Audit Trail')
                SNDPGMMSG  MSG(&MSG) TOMSGQ(MRUNQ)
/**/
             CALL       PGM(EM0400)
                                                                      /*E22940*/
/*  Drop deleted records from file                                 */ /*E22940*/
/**********  RGZPFM     FILE(EMLIML2)                                 /*E22940*/          /*228542*/
/**********  MONMSG     MSGID(CPF0000)                                /*E40394*/          /*228542*/
             CALL       PGM(SCC000060) PARM('EMLIML2' '*FIRST')                           /*228542*/
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
           ENDPGM
