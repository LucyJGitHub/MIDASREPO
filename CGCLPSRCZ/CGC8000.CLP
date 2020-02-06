/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas CG Common shell program.')                      */
/*********************************************************************/
/*                                                                   */
/*       Midas     - User Defined Correspondence                     */
/*                                                                   */
/*       CGC8000 - - Common transfer destination shell               */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. S01522             Date 01Jan95              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       S01522 - User Defined Correspondence                        */
/*                                                                   */
/*********************************************************************/
 
      PGM  &RETURN
 
      DCL  &RETURN  *CHAR   7          /*  Return code.              */
 
      DCL  &NEXT    *CHAR  10          /*  Next program.             */
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
/*===================================================================*/
/*  Get the name of the next program to be executed:                 */
 
      RTVDTAARA (*LDA (813 10))  &NEXT
 
      IF   (&NEXT *EQ '      ') (GOTO PGM1)      /*  CG8000.         */
      IF   (&NEXT *EQ 'CG8000') (GOTO PGM1)      /*  CG8000.         */
      IF   (&NEXT *EQ 'CG8100') (GOTO PGM2)      /*  CG8100.         */
      IF   (&NEXT *EQ 'CG8200') (GOTO PGM3)      /*  CG8200.         */
      IF   (&NEXT *EQ 'CG8300') (GOTO PGM4)      /*  CG8300.         */
      IF   (&NEXT *EQ 'CG8400') (GOTO PGM5)      /*  CG8400.         */
 
      GOTO BADP                        /*  None of the above.        */
 
/*-------------------------------------------------------------------*/
/*  Execute CG8000 -- Generate RDE data for a group set.             */
 
PGM1: CALL CG8000  &RETURN
 
      GOTO LOOP
 
/*-------------------------------------------------------------------*/
/*  Execute CG8100 -- Work with planes function.                     */
 
PGM2: CALL CG8100  &RETURN
 
      GOTO LOOP
 
/*-------------------------------------------------------------------*/
/*  Execute CG8200 -- Work with a plane.                             */
 
PGM3: CALL CG8200  &RETURN
 
      GOTO LOOP
 
/*-------------------------------------------------------------------*/
/*  Execute CG8300 -- Work with conditions application.              */
 
PGM4: CALL CG8300  &RETURN
 
      GOTO LOOP
 
/*-------------------------------------------------------------------*/
/*  Execute CG8400 -- Work with conditions combination.              */
 
PGM5: CALL CG8400  &RETURN
 
      GOTO LOOP
 
/*===================================================================*/
/*  Transfer to CG8999 for the next program:                         */
 
LOOP: TFRCTL CGC8999 &RETURN
 
/*===================================================================*/
/*  Handle an invalid &NEXT value:                                   */
 
BADP: SNDPGMMSG *N CPF9898 QCPFMSG +
        ('An invalid program was given as the next +
          to be called -- ' *CAT &NEXT)
 
/*===================================================================*/
 
END:  CHGDTAARA (*LDA (805 28)) '                            '
 
      RCLRSC *CALLER
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
      ENDPGM
