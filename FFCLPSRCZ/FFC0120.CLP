/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas FF Add physical file members')                  */
/*********************************************************************/
/*                                                                   */
/*   Midas - Futures and Options Module                      */
/*                                                                   */
/*   FFC0120 - ADD PHYSICAL FILE MEMBER TO FILES                     */
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
/*     CHANGE DESCRIPTIONS                                           */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*   178066 - File names can now be up to 10 long - need to extend   */
/*            array elements and variable definitions to allow for   */
/*            this.                                                  */
/*-------------------------------------------------------------------*/
/*     CREATION REQUIREMENTS                                         */
/*                                                                   */
/*********************************************************************/
             PGM (&MRKT &IND)
/**/
/* Declare Variables                                                */
/**/
             DCL        VAR(&X) TYPE(*DEC) LEN(2 0) VALUE(0)
             DCL        VAR(&Y) TYPE(*DEC) LEN(3 0) VALUE(0)
/************DCL        VAR(&FILE) TYPE(*CHAR) LEN(8)                  *178066*/
             DCL        VAR(&FILE) TYPE(*CHAR) LEN(10)                /*178066*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/*/COPY WNCPYSRC,FFC0120001                                          */
/**/
/* Declare parameters                                               */
/**/
             DCL        VAR(&MRKT) TYPE(*CHAR) LEN(2)
             DCL        VAR(&IND) TYPE(*CHAR) LEN(1)
/**/
             DCLF       FILE(FFMMFD)
/*/COPY WNCPYSRC,FFC0120002                                          */
/**/
/* CLEAR PHYSICAL FILE MEMBER                                       */
/**/
             CLRPFM     FILE(FFMMFD)
/**/
/* CALL FF0002 - Set Up Multi-member File list                      */
/**/
             CALL       PGM(FF0002) PARM('P')
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
/*/COPY WNCPYSRC,FFC0120003                                          */
/**/
             ADDPFM     FILE(&FILE) MBR(&MRKT) SHARE(*YES)
             MONMSG     MSGID(CPF7306)
/*/COPY WNCPYSRC,FFC0120004                                          */
             CHGVAR VAR(&X) VALUE(&X+1)
/**/
             GOTO LOOP
/**/
             ENDDO
/*                                                                  */
 END:        OVRDBF     FILE(FOKEYA) MBR(&MRKT)
             OVRDBF     FILE(PRICSA) MBR(&MRKT)
             OVRDBF     FILE(PRISPA) MBR(&MRKT)
             OVRDBF     FILE(TRANSA) MBR(&MRKT)
/**/
/* CALL FF0001 - Set Up Multi-member Audit File records             */
/**/
             CALL       PGM(FF0001)
/*                                                                  */
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             RCLRSC
             ENDPGM
