/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas MQ DSPFFD for a File')                          */
/*********************************************************************/
/*                                                                   */
/*      Midas - Midas/Q Module                                       */
/*                                                                   */
/*      MQ502XC - DSPFFD Returns file in RETURN if FIELD is found    */
/*                in FILE, otherwise returns *BLANKS in RETURN       */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. CPK025             Date 11Jul06              */
/*       Prev Amend No. BUG8856            Date 07Oct05              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CMQ001             Date 31OCT97              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CPK025  - File UPCDFDPD is redundant. Use file UPFFDSTPD.   */
/*       BUG8856 - DSPFFD changed at V5R3. Use core outfile instead  */
/*       CMQ001 - MidasQ rationalisation.                            */
/*                                                                   */
/*********************************************************************/
/**/
             PGM        PARM(&FIELD &FILE &RETURN &CALLED)
/**/
             DCL        VAR(&FIELD) TYPE(*CHAR) LEN(6)
             DCL        VAR(&FILE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&RETURN) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CALLED) TYPE(*CHAR) LEN(1)
/**/
/**********  DCLF       FILE(QADSPFFD)                               */                  /*BUG8856*/
/**********  DCLF       FILE(UPCDFDPD)                               */           /*BUG8856 CPK025*/
             DCLF       FILE(UPFFDSTPD)                                                   /*CPK025*/
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
                                                                                         /*BUG8856*/
/* Set up outfile QTEMP/TEMP1 */                                                         /*BUG8856*/
             DLTF       FILE(QTEMP/TEMP1)                                                /*BUG8856*/
             MONMSG     MSGID(CPF0000)                                                   /*BUG8856*/
/**********  CPYF       FROMFILE(UPCDFDPD) TOFILE(QTEMP/TEMP1) +                       */ /*CPK025*/
/**********               CRTFILE(*YES)                             */            /*BUG8856 CPK025*/
             CPYF       FROMFILE(UPFFDSTPD) TOFILE(QTEMP/TEMP1) +
                          CRTFILE(*YES)                                                   /*CPK025*/
 
/**/
/* Override QADSPFFD to QTEMP/TEMP1 */
/**********  OVRDBF     FILE(QADSPFFD) TOFILE(QTEMP/TEMP1)           */                  /*BUG8856*/
/**********  OVRDBF     FILE(UPCDFDPD) TOFILE(QTEMP/TEMP1) +                           */ /*CPK025*/
/**********               OVRSCOPE(*JOB)                                   */ /*BUG8856*/ /*CPK025*/
             OVRDBF     FILE(UPFFDSTPD) TOFILE(QTEMP/TEMP1) +
                          OVRSCOPE(*JOB)                                                  /*CPK025*/
 
/**/
/** Only DSPFFD if it is the first call **/
             IF         COND(&CALLED *EQ ' ') THEN(DO)
             CHGVAR     VAR(&CALLED) VALUE('Y')
             DSPFFD     FILE(*LIBL/&FILE) OUTPUT(*OUTFILE) +
                          OUTFILE(QTEMP/DSPFFD)
                          ENDDO
/**/
/* CPYF TO SEE IF FIELD IS IN FILE */
/**********  CPYF       FROMFILE(QTEMP/DSPFFD) TOFILE(QTEMP/TEMP1) + */                  /*BUG8856*/
/**********               MBROPT(*REPLACE) CRTFILE(*YES) +           */                  /*BUG8856*/
/**********               INCCHAR(WHFLDI 1 *EQ &FIELD)               */                  /*BUG8856*/
             CPYF       FROMFILE(QTEMP/DSPFFD) TOFILE(QTEMP/TEMP1) +
                          MBROPT(*REPLACE) CRTFILE(*YES) +
                          INCCHAR(WHFLDI 1 *EQ &FIELD) FMTOPT(*DROP)                     /*BUG8856*/
 
/**/
/* If RCVF Fails field is not in FILE */
             RCVF
             MONMSG     MSGID(CPF0000 MCH0000) EXEC(DO)
             CHGVAR     VAR(&RETURN) VALUE('          ')
             GOTO       CMDLBL(ENDPGM)
             ENDDO
 
             CHGVAR     VAR(&RETURN) VALUE(&FILE)
 
 ENDPGM:
/**********  DLTOVR     FILE(UPCDFDPD) LVL(*JOB)                     */           /*BUG8856 CPK025*/
             DLTOVR     FILE(UPFFDSTPD) LVL(*JOB)                                         /*CPK025*/
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000)                                   /*BUG8856*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
