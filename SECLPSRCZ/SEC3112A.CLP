/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SE EXTEL Tape Device Check')                    */
/********************************************************************/
/*                                                                  */
/*         Midas     - Securities Trading Module                */
/*                                                                  */
/*        SEC3112A - EXTEL TAPE DEVICE CHECK                        */
/*                                                                  */
/*      (c) Finastra International Limited 2001                     */
/*                                                                  */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*        PREV AMEND NO.                    DATE 00/00/00           */
/*                                                                  */
/*------------------------------------------------------------------*/
/*       Description of Amendment.                                  */
/*       MD046248 - Finastra Rebranding                             */
/*       No. 00     Text:                                           */
/*                                                                  */
/********************************************************************/
/*    CL PROGRAM TO CHECK IF TAPE DEVICE IS VALID                   */
 
/*********************************************************************/
             PGM        PARM(&TDEV &TDVIND)
 
 
             DCL        &TDEV   *CHAR 10
             DCL        VAR(&TDVIND) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
             CHKTAP     DEV(&TDEV)
 
             MONMSG     MSGID(CPF6721 CPF9814 CPD0000 MCH0000 +
                          CPF0001) EXEC(DO)
               CHGVAR     VAR(&TDVIND) VALUE('2')
               GOTO ENDPGM
             ENDDO
 
             MONMSG     MSGID(CPF0000) EXEC(DO)
               CHGVAR     VAR(&TDVIND) VALUE('1')
               GOTO ENDPGM
             ENDDO
 
 
 ENDPGM:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
