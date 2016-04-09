/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas FF Recreate LFs over all PF members')           */
/*********************************************************************/
/*                                                                   */
/*   Midas  -  Futures and Options Module                            */
/*                                                                   */
/*   FFC0140  -  RECREATE LOGICAL FILES OVER ALL PF MEMBERS          */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.03 ---------------------------------------------------*/
/*   Last Amend No. 178066             Date 11Jul00                  */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*   Prev Amend No. N00000             DATE DDMMMYY                  */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*   178066 - File names can now be up to 10 long - need to extend   */
/*            array elements and variable definitions to allow for   */
/*            this.                                                  */
/*                                                                   */
/*********************************************************************/
             PGM (&IND)
/**/
/* Declare variables                                                */
/**/
             DCL        VAR(&IND) TYPE(*CHAR) LEN(1)
             DCL        VAR(&X) TYPE(*DEC) LEN(2 0) VALUE(0)
             DCL        VAR(&Y) TYPE(*DEC) LEN(3 0) VALUE(0)
/************DCL        VAR(&FILE) TYPE(*CHAR) LEN(8)                  *178066*/
             DCL        VAR(&FILE) TYPE(*CHAR) LEN(10)                /*178066*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/**/
             DCLF       FILE(FFMMFD)
/**/
/*   SEND MESSAGE TO MSGQ/MRUNQ                                    */
/**/
             SNDPGMMSG  MSG('FFC0140 - Futures and Options Recreate +
                         Logical Files') TOMSGQ(MRUNQ)
/**/
/* CLEAR PHYSICAL FILE MEMBER                                       */
/**/
             CLRPFM     FILE(FFMMFD)
/**/
/* CALL FF0002 - Set Up Single member File list                      */
/**/
             CALL       PGM(FF0002) PARM('X')
/**/
             RCVF
/**/
/*OOP:*******CHGVAR VAR(&Y) VALUE((8*&X)+1)                            *178066*/
 LOOP:       CHGVAR VAR(&Y) VALUE((10*&X)+1)                          /*178066*/
/**/
/************CHGVAR VAR(&FILE) VALUE(%SST(&FMMF &Y 8))                 *178066*/
             CHGVAR VAR(&FILE) VALUE(%SST(&FMMF &Y 10))               /*178066*/
/**/
             IF  COND(&FILE *NE ' ') THEN(DO)
/**/
             RMVM       FILE(&FILE) MBR(&FILE)
             MONMSG     MSGID(CPF5815)
             ADDLFM     FILE(&FILE) MBR(&FILE) SHARE(*YES)
             CHGVAR VAR(&X) VALUE(&X+1)
/**/
             GOTO LOOP
/**/
             ENDDO
/*                                                                  */
 END:        RCLRSC
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
