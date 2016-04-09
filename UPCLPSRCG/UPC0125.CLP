/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas UP Add/remove job queue entries to subsystem')  */
/*********************************************************************/
/*                                                                   */
/*       Midas - Upgrade Module                                      */
/*                                                                   */
/*       UPC0125 - Add job queue entries to subsystem                */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. CPK018             Date 16Mar04              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.05 ---------------------------------------------------*/
/*       Prev Amend No. CUP013 *CREATE     Date 01Feb01              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CPK018 - MidasPlus packaging.  Handle global processing.    */
/*       CUP013 - New program to change job queue entries for sub-   */
/*                 system.                                           */
/*                                                                   */
/*********************************************************************/
/**********  PGM        PARM(&OLDLIB &SBSID &JOBQ &SEQ &MAXA &MAX1 +                   */ /*CPK018*/
/**********               &MAX2 &MAX3 &MAX4 &MAX5 &MAX6 &MAX7 &MAX8 +                  */ /*CPK018*/
/**********               &MAX9 &ERROR)                                                */ /*CPK018*/
             PGM        PARM(&OLDLIB &XLIB &SUBSYSTEM &JOBQ &SEQ +
                          &MAXA &MAX1 &MAX2 &MAX3 &MAX4 &MAX5 &MAX6 +
                          &MAX7 &MAX8 &MAX9 &ERROR)                                       /*CPK018*/
 
             DCL        VAR(&OLDLIB) TYPE(*CHAR) LEN(10)
/**********  DCL        VAR(&SBSID) TYPE(*CHAR) LEN(2)                                 */ /*CPK018*/
             DCL        VAR(&JOBQ) TYPE(*CHAR) LEN(10)
             DCL        VAR(&SEQ) TYPE(*CHAR) LEN(3)
             DCL        VAR(&MAXA) TYPE(*CHAR) LEN(6)
             DCL        VAR(&MAX1) TYPE(*CHAR) LEN(6)
             DCL        VAR(&MAX2) TYPE(*CHAR) LEN(6)
             DCL        VAR(&MAX3) TYPE(*CHAR) LEN(6)
             DCL        VAR(&MAX4) TYPE(*CHAR) LEN(6)
             DCL        VAR(&MAX5) TYPE(*CHAR) LEN(6)
             DCL        VAR(&MAX6) TYPE(*CHAR) LEN(6)
             DCL        VAR(&MAX7) TYPE(*CHAR) LEN(6)
             DCL        VAR(&MAX8) TYPE(*CHAR) LEN(6)
             DCL        VAR(&MAX9) TYPE(*CHAR) LEN(6)
 
             DCL        VAR(&SEQN) TYPE(*DEC) LEN(3 0)
             DCL        VAR(&MAXAN) TYPE(*DEC) LEN(4 0)
             DCL        VAR(&MAX1N) TYPE(*DEC) LEN(2 0)
             DCL        VAR(&MAX2N) TYPE(*DEC) LEN(2 0)
             DCL        VAR(&MAX3N) TYPE(*DEC) LEN(2 0)
             DCL        VAR(&MAX4N) TYPE(*DEC) LEN(2 0)
             DCL        VAR(&MAX5N) TYPE(*DEC) LEN(2 0)
             DCL        VAR(&MAX6N) TYPE(*DEC) LEN(2 0)
             DCL        VAR(&MAX7N) TYPE(*DEC) LEN(2 0)
             DCL        VAR(&MAX8N) TYPE(*DEC) LEN(2 0)
             DCL        VAR(&MAX9N) TYPE(*DEC) LEN(2 0)
 
             DCL        VAR(&XLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&SUBSYSTEM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&ERROR) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
/* Global monitor message */
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/**********  CHGVAR     VAR(&XLIB) VALUE(&SBSID *TCAT 'XLIB')                          */ /*CPK018*/
/**********  CHGVAR     VAR(&SUBSYSTEM) VALUE('M' *TCAT &SBSID *TCAT +                 */ /*CPK018*/
/**********               'SBS')                                                       */ /*CPK018*/
 
/* Remove job queue entry from subsystem. */
             RMVJOBQE   SBSD(&XLIB/&SUBSYSTEM) JOBQ(&OLDLIB/&JOBQ)
 
/* Add job queue entry with basic information. */
             CHGVAR     VAR(&SEQN) VALUE(&SEQ)
             ADDJOBQE   SBSD(&XLIB/&SUBSYSTEM) JOBQ(&XLIB/&JOBQ) +
                          SEQNBR(&SEQN)
 
/* -then add further changes depending on whether value is numeric */
/*  or *NOMAX.                                                     */
             IF         COND(&MAXA *NE '*NOMAX') THEN(DO)
                CHGVAR     VAR(&MAXAN) VALUE(&MAXA)
                CHGJOBQE   SBSD(&XLIB/&SUBSYSTEM) JOBQ(&XLIB/&JOBQ) +
                          MAXACT(&MAXAN)
             ENDDO
             ELSE       CMD(DO)
                CHGJOBQE   SBSD(&XLIB/&SUBSYSTEM) JOBQ(&XLIB/&JOBQ) +
                          MAXACT(&MAXA)
             ENDDO
             IF         COND(&MAX1 *NE '*NOMAX') THEN(DO)
                CHGVAR     VAR(&MAX1N) VALUE(&MAX1)
                CHGJOBQE   SBSD(&XLIB/&SUBSYSTEM) JOBQ(&XLIB/&JOBQ) +
                          MAXPTY1(&MAX1N)
             ENDDO
             ELSE       CMD(DO)
                CHGJOBQE   SBSD(&XLIB/&SUBSYSTEM) JOBQ(&XLIB/&JOBQ) +
                          MAXPTY1(&MAX1)
             ENDDO
             IF         COND(&MAX2 *NE '*NOMAX') THEN(DO)
                CHGVAR     VAR(&MAX2N) VALUE(&MAX2)
                CHGJOBQE   SBSD(&XLIB/&SUBSYSTEM) JOBQ(&XLIB/&JOBQ) +
                          MAXPTY2(&MAX2N)
             ENDDO
             ELSE       CMD(DO)
                CHGJOBQE   SBSD(&XLIB/&SUBSYSTEM) JOBQ(&XLIB/&JOBQ) +
                          MAXPTY2(&MAX2)
             ENDDO
             IF         COND(&MAX3 *NE '*NOMAX') THEN(DO)
                CHGVAR     VAR(&MAX3N) VALUE(&MAX3)
                CHGJOBQE   SBSD(&XLIB/&SUBSYSTEM) JOBQ(&XLIB/&JOBQ) +
                          MAXPTY3(&MAX3N)
             ENDDO
             ELSE       CMD(DO)
                CHGJOBQE   SBSD(&XLIB/&SUBSYSTEM) JOBQ(&XLIB/&JOBQ) +
                          MAXPTY3(&MAX3)
             ENDDO
             IF         COND(&MAX4 *NE '*NOMAX') THEN(DO)
                CHGVAR     VAR(&MAX4N) VALUE(&MAX4)
                CHGJOBQE   SBSD(&XLIB/&SUBSYSTEM) JOBQ(&XLIB/&JOBQ) +
                          MAXPTY4(&MAX4N)
             ENDDO
             ELSE       CMD(DO)
                CHGJOBQE   SBSD(&XLIB/&SUBSYSTEM) JOBQ(&XLIB/&JOBQ) +
                          MAXPTY4(&MAX4)
             ENDDO
             IF         COND(&MAX5 *NE '*NOMAX') THEN(DO)
                CHGVAR     VAR(&MAX5N) VALUE(&MAX5)
                CHGJOBQE   SBSD(&XLIB/&SUBSYSTEM) JOBQ(&XLIB/&JOBQ) +
                          MAXPTY5(&MAX5N)
             ENDDO
             ELSE       CMD(DO)
                CHGJOBQE   SBSD(&XLIB/&SUBSYSTEM) JOBQ(&XLIB/&JOBQ) +
                          MAXPTY5(&MAX5)
             ENDDO
             IF         COND(&MAX6 *NE '*NOMAX') THEN(DO)
                CHGVAR     VAR(&MAX6N) VALUE(&MAX6)
                CHGJOBQE   SBSD(&XLIB/&SUBSYSTEM) JOBQ(&XLIB/&JOBQ) +
                          MAXPTY6(&MAX6N)
             ENDDO
             ELSE       CMD(DO)
                CHGJOBQE   SBSD(&XLIB/&SUBSYSTEM) JOBQ(&XLIB/&JOBQ) +
                          MAXPTY6(&MAX6)
             ENDDO
             IF         COND(&MAX7 *NE '*NOMAX') THEN(DO)
                CHGVAR     VAR(&MAX7N) VALUE(&MAX7)
                CHGJOBQE   SBSD(&XLIB/&SUBSYSTEM) JOBQ(&XLIB/&JOBQ) +
                          MAXPTY7(&MAX7N)
             ENDDO
             ELSE       CMD(DO)
                CHGJOBQE   SBSD(&XLIB/&SUBSYSTEM) JOBQ(&XLIB/&JOBQ) +
                          MAXPTY7(&MAX7)
             ENDDO
             IF         COND(&MAX8 *NE '*NOMAX') THEN(DO)
                CHGVAR     VAR(&MAX8N) VALUE(&MAX8)
                CHGJOBQE   SBSD(&XLIB/&SUBSYSTEM) JOBQ(&XLIB/&JOBQ) +
                          MAXPTY8(&MAX8N)
             ENDDO
             ELSE       CMD(DO)
                CHGJOBQE   SBSD(&XLIB/&SUBSYSTEM) JOBQ(&XLIB/&JOBQ) +
                          MAXPTY8(&MAX8)
             ENDDO
             IF         COND(&MAX9 *NE '*NOMAX') THEN(DO)
                CHGVAR     VAR(&MAX9N) VALUE(&MAX9)
                CHGJOBQE   SBSD(&XLIB/&SUBSYSTEM) JOBQ(&XLIB/&JOBQ) +
                          MAXPTY9(&MAX9N)
             ENDDO
             ELSE       CMD(DO)
                CHGJOBQE   SBSD(&XLIB/&SUBSYSTEM) JOBQ(&XLIB/&JOBQ) +
                          MAXPTY9(&MAX9)
             ENDDO
 
             GOTO       CMDLBL(ENDPGM)
 
 ABNOR:
             CHGVAR     VAR(&ERROR) VALUE('Y')
 
 ENDPGM:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
