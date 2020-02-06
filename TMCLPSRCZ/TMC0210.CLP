/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas TM Control MM Take On')                         */
/********************************************************************/
/*                                                                  */
/*      Midas - Treasury Management Module                  */
/*                                                                  */
/*      TMC0210 -  CONTROL TAKEON OF MIDAS MM DEALS                 */
/*                                                                  */
/*      Function:  Controls take-on of MM trades.  It will run      */
/*                 when the Treasury Management module is switched  */
/*                 on in an existing system in phase 'D'. All deals */
/*                 must be authorised before it is run.             */
/*                 This program is based on FD0800.                 */
/*                                                                  */
/*       Called by: TMC0100 - TM Take-on menu.                      */
/*                                                                  */
/*       Calls:     MM8010 - Start of day reorganisation control.   */
/*                                                                  */
/*       (c) Finastra International Limited 2001                     */
/*                                                                  */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*      PREV AMEND NO. XXXXXX             DATE   99XXX99            */
/*                                                                  */
/********************************************************************/
/*       MD046248 - Finastra Rebranding                             */
/*                                                                  */
/********************************************************************/
             PGM
/**/
             DCL        VAR(&TERM)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**/
/**  CALL MM8010                                                     */
/**  TO REBUILD MM FILES. MM8010 IS NORMALLY RUN AS PART OF NEXT DAY */
/**  SET UP AND RELIES ON DTAARA/MPHAS BEING SET TO 'F' TO WORK      */
             IF         COND(%SWITCH(XXXXX000)) THEN(DO)
                CALL       PGM(MM8010) PARM(&TERM)
 
                IF         COND(&TERM *EQ 'E') THEN(DO)
                           GOTO ERROR
                ENDDO
 
             ENDDO
/**/
 
             GOTO END
/**/
/* If called program sets on termination parameter dont overwrite LDA*/
/**/
 ERROR:      IF         COND(&TERM *NE 'E' *OR &TERM *NE 'T') THEN(DO)
                 CHGJOB     SWS(XXXXX1XX)
                 MONMSG     MSGID(CPF0000)
                 CHGDTAARA  DTAARA(*LDA (171 10)) VALUE('TMC0210   ')
                 MONMSG     MSGID(CPF0000)
                 CHGDTAARA  DTAARA(*LDA (181 3)) VALUE('001')
                 MONMSG     MSGID(CPF0000)
             ENDDO
 
             DMPCLPGM
             SNDPGMMSG  MSG('Error occurred in takeon - sort out +
                          problem then take option 7 to retry') +
                          TOPGMQ(*PRV)
             MONMSG     MSGID(CPF0000)
 END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
