/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas TM Control AB Take On')                         */
/********************************************************************/
/*                                                                  */
/*      Midas - Treasury Management Module                  */
/*                                                                  */
/*      TMC0310 -  CONTROL TAKEON OF MIDAS AB DEALS                 */
/*                                                                  */
/*      Function:  Controls take-on of AB trades.  It will run      */
/*                 when the Treasury Management module is switched  */
/*                 on in an existing system in phase 'D'. All deals */
/*                 must be authorised before it is run.             */
/*                 This program is based on FD0870.                 */
/*                                                                  */
/*       Called by: TMC0100 - TM Take-on menu.                      */
/*                                                                  */
/*       Calls:     TM0320 - Update BCDE on ABDEALPP and FX takeon  */
/*                           of AB deals.                           */
/*                  FX0680 - FX Revaluation processing.             */
/*                  AB8010 - AB deals update & start of day reorg.  */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*      LAST AMEND NO. XXXXXX             DATE   99XXX99            */
/*                                                                  */
/********************************************************************/
     PGM
             DCL        VAR(&ERROR) TYPE(*CHAR) LEN(1)
             DCL        VAR(&TERM)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/**/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ERROR))
 
/**/
/**  CALL PROGRAM TM0320 TO UPDATE BASE CURRENCY FOR DEALING    **/
/**  EQUIVALENTS ON ABDEALPP, AND TAKEON AB DEALS (FX FILES).   **/
             CALL       PGM(TM0320) PARM(&ERROR)
 
             IF         COND(&ERROR *EQ 'E') THEN(DO)
                SNDPGMMSG  MSG('Error in TM0320, see dump') +
                TOPGMQ(*PRV)
                GOTO       CMDLBL(ERROR)
             ENDDO
 
             COMMIT
 
/** Call FX0680 to update positions file with online and nostro      */
/** positions.                                                       */
             CALL       PGM(FX0680)
 
/** If an error has occurred in the called program, end this program */
/** in error.                                                        */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                SNDPGMMSG  MSG('Error in FX0680, see dump') +
                TOPGMQ(*PRV)
                GOTO       CMDLBL(ERROR)
             ENDDO
 
/**/
/*  IF PREVIOUS CALL TO TM0320 COMPLETED SUCCESSFULLY CALL AB8010 */
/**  TO REBUILD MM FILES. */
             IF         COND(%SWITCH(XXXXX000)) THEN(DO)
                CALL       PGM(AB8010) PARM(&TERM)
 
                IF         COND(&TERM *EQ 'E') THEN(DO)
                           GOTO ERROR
                           ENDDO
                ENDDO
 
             COMMIT
             RCLRSC
             GOTO       CMDLBL(END)
/**/
/* If called program sets on termination parameter dont overwrite LDA*/
/**/
 ERROR:      IF         COND(&TERM *NE 'E' *AND &TERM *NE 'T') THEN(DO)
                 CHGJOB     SWS(XXXXX1XX)
                 MONMSG     MSGID(CPF0000)
                 CHGDTAARA  DTAARA(*LDA (171 10)) VALUE('TMC0310   ')
                 MONMSG     MSGID(CPF0000)
                 CHGDTAARA  DTAARA(*LDA (181 3)) VALUE('001')
                 MONMSG     MSGID(CPF0000)
             ENDDO
 
             ROLLBACK
             RCLRSC
             MONMSG     MSGID(CPF0000)
             DMPCLPGM
             MONMSG     MSGID(CPF0000)
             SNDPGMMSG  MSG('Error occurred in takeon - sort out +
                          problem then take option 8 to retry') +
                          TOPGMQ(*PRV)
             MONMSG     MSGID(CPF0000)
 END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
