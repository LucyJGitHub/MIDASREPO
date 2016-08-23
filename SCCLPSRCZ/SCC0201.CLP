/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SC Validate Midas user at signon')              */
/*********************************************************************/
/*                                                                   */
/*       Midas - System Control Module                               */
/*                                                                   */
/*       SCC0201 - Validate Midas User at Signon                     */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2003           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. CAAA02 *CREATE     Date 06Sep03              */
/*       Prev Amend No. Xnnnnn             Date ddmmmyy              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CAAA02 - Webfacing Enhancement (Replaces SCC0101)           */
/*                                                                   */
/*********************************************************************/
             PGM
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2003')
             DCL        VAR(&GROUP) TYPE(*CHAR) LEN(50)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(25)
             DCL        VAR(&SLEVEL) TYPE(*DEC) LEN(4)
             DCL        VAR(&TIMEO) TYPE(*DEC) LEN(5)
             DCL        VAR(&ERRORC) TYPE(*DEC) LEN(1) VALUE(0)
             DCL        VAR(&MULT) TYPE(*CHAR) LEN(2)
             DCL        VAR(&PARM1) TYPE(*CHAR) LEN(200)
             DCL        VAR(&PARM2) TYPE(*CHAR) LEN(200)
             DCL        VAR(&PARM3) TYPE(*CHAR) LEN(200)
             DCL        VAR(&PARM4) TYPE(*CHAR) LEN(200)
             DCL        VAR(&PARM5) TYPE(*CHAR) LEN(200)
             DCL        VAR(&MESSAGE) TYPE(*CHAR) LEN(50)
             DCL        VAR(&JOBSWITCH) TYPE(*CHAR) LEN(8)
 
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/* Check to see if the user is authorised to the system */
 
             CALL       PGM(SF0410) PARM(&GROUP &USER &SLEVEL &TIMEO +
                          &ERRORC &MULT)
 
             IF         COND(&MULT *EQ '  ') THEN(DO)
                CHGVAR     VAR(&MULT) VALUE('GB')
             ENDDO
 
/* Terminate job if user is not defined to the system */
 
             IF         COND(&ERRORC *EQ 1) THEN(DO)
 
/* Call Midas information screen to inform the user that they */
/* are not authorised to this Midas system                    */
 
                RTVMSG     MSGID(SCM0036) MSGF(GBMIDASMSG) +
                             MSG(&MESSAGE)
                CHGDTAARA  DTAARA(MIDASMSG (251 50)) VALUE(&MESSAGE)
                RTVMSG     MSGID(SCM0037) MSGF(GBMIDASMSG) +
                             MSG(&MESSAGE)
                CHGDTAARA  DTAARA(MIDASMSG (351 50)) VALUE(&MESSAGE)
                CHGDTAARA  DTAARA(MIDASMSG (18 1)) VALUE('1')
                CALL       PGM(SCC0010) PARM('SCC0101' 'ENTER' +
                             ' ')
 
/* Sign the user off */
                SIGNOFF    LOG(*LIST)
 
             ENDDO
 
/* If user exists then allow them to proceed to the next set */
/* of entry checks via multiple language support initiation  */
 
             CHGVAR     VAR(%SST(&PARM1 1 5)) VALUE(&TIMEO)
             CHGVAR     VAR(%SST(&PARM1 6 50)) VALUE(&GROUP)
             CHGVAR     VAR(%SST(&PARM1 56 25)) VALUE(&USER)
             CHGVAR     VAR(%SST(&PARM1 81 4)) VALUE(&SLEVEL)
             CHGVAR     VAR(%SST(&PARM1 85 1)) VALUE(&ERRORC)
 
             CALL       PGM(MLC0000) PARM('SCC0202' &PARM1 &PARM2 +
                          &PARM3 &PARM4 &PARM5)
 
             RTVJOBA    SWS(&JOBSWITCH)
 
             IF         COND(%SST(&JOBSWITCH 7 2) *EQ '11') +
                          THEN(GOTO CMDLBL(SIGNOFF))
 
             GOTO       CMDLBL(END)
 
 ABNOR:
 
             SNDPGMMSG  MSG('Midas user validation terminated +
                          abnormally') TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000)
 
/* Call SCC0010 to inform the user that an error has occurred */
 
             RTVMSG     MSGID(SCM0073) MSGF(GBMIDASMSG) MSG(&MESSAGE)
             MONMSG     MSGID(CPF0000 MCH0000)
 
             CHGDTAARA  DTAARA(MIDASMSG (251 50)) VALUE(&MESSAGE)
             MONMSG     MSGID(CPF0000 MCH0000)
 
             CALL       PGM(SCC0010) PARM('SCC0101' 'ENTER' ' ')
             MONMSG     MSGID(CPF0000 MCH0000)
 
 SIGNOFF:
             SIGNOFF    LOG(*LIST)
             MONMSG     MSGID(CPF0000 MCH0000)
 
END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
