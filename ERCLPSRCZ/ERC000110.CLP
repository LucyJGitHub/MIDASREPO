/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('@24 KWG response file processing')                    */
/*********************************************************************/
/*                                                                   */
/*       Midas European Reporting Module                             */
/*                                                                   */
/*       ERC000110 - §24 KWG response file processing                */
/*                                                                   */
/*       (c) Finastra International Limited 2022                     */
/*                                                                   */
/*       Last Amend No. BUG25857B*CREATE    Date 04Jul22             */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       BUG25857B - Various error on KWG                            */
/*                 - Applied for MD058462.                           */
/*                                                                   */
/*********************************************************************/
             PGM

             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(C) +
                      Copyright Finastra International Limited 2022.')
             DCL        VAR(&H) TYPE(*DEC) LEN(2 0)
             DCL        VAR(&M) TYPE(*DEC) LEN(2 0)
             DCL        VAR(&S) TYPE(*DEC) LEN(2 0)
             DCL        VAR(&CLOCK) TYPE(*CHAR) LEN(6)
             DCL        VAR(&SYSPR) TYPE(*CHAR) LEN(2)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRTCD) TYPE(*CHAR) LEN(7)
             DCL        VAR(&PFMT) TYPE(*CHAR) LEN(200)
             DCL        VAR(&PSARD) TYPE(*CHAR) LEN(6)
             DCL        VAR(&POPTN) TYPE(*CHAR) LEN(7)

/** Check if SAR CER047 is installed */

             CHGVAR     VAR(&PRTCD) VALUE('       ')
             CHGVAR     VAR(&POPTN) VALUE('*VERIFY')
             CHGVAR     VAR(&PSARD) VALUE('CER047')
             CALL       PGM(AOSARDR0) PARM(&PRTCD &POPTN &PSARD &PFMT)

/** If an error ocurred  */

             IF         COND((&PRTCD *NE '       ') *AND (&PRTCD *NE +
                          '*NRF    ')) THEN(DO)
               SNDPGMMSG  MSG('AOSARDR0 - Program Error') +
                TOMSGQ(MOPERQ)
               CHGJOB     SWS('XXXXXX11')
               GOTO       CMDLBL(END)
             ENDDO

/** If CER047 is OFF, end program */

             IF         COND(&PRTCD *NE '       ') THEN(DO)
               GOTO       CMDLBL(END)
             ENDDO

/* Call response file renamer                                        */
             CALL       PGM(ER000140)

/* Call response file receiver with multilanguage support            */
             CALL       PGM(MLC0000) PARM('ER000110  ' ' ' ' ' ' ' ' +
                          ' ' ')

/* Add 30 Minutes to current time                                    */
             RTVSYSVAL  SYSVAL(QTIME) RTNVAR(&CLOCK)
             CHGVAR     VAR(&H) VALUE(%SST(&CLOCK 1 2))
             CHGVAR     VAR(&M) VALUE(%SST(&CLOCK 3 2))
             CHGVAR     VAR(&S) VALUE(%SST(&CLOCK 5 2))
             CHGVAR     VAR(&M) VALUE(&M + 30)             /* Add 30 minutes        */
             IF         COND(&M *GE 60) THEN(DO)           /* If minutes exceeds 60 */
             CHGVAR     VAR(&M) VALUE(&M - 60)             /* Subtract 60 minutes   */
             CHGVAR     VAR(&H) VALUE(&H + 1)              /* Add 1 hour            */
             IF         COND(&H *GE 24) THEN(DO)           /* If hours exceed 24    */
             CHGVAR     VAR(&H) VALUE(&H - 24)             /* Subtract 24 hours     */
             DLYJOB     RSMTIME(000000)                    /* Delay job to ensure, during submit */
             ENDDO                                         /* the next day is used               */
             ENDDO
             CHGVAR     VAR(%SST(&CLOCK 1 2)) VALUE(&H)
             CHGVAR     VAR(%SST(&CLOCK 3 2)) VALUE(&M)
             CHGVAR     VAR(%SST(&CLOCK 5 2)) VALUE(&S)
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&SYSPR)
             CHGVAR     VAR(&USER) VALUE(&SYSPR *CAT 'OWNER')

/* Resubmit job 30 minutes later only if 18:00:00 not exceeded       */
             IF         COND(&H *LT 18) THEN(DO)
             SBMJOB     CMD(CALL PGM(ERC000110)) JOB(ERC000110) +
                          JOBD(BULKTJOBD) JOBQ(*JOBD) JOBPTY(*JOBD) +
                          OUTPTY(*JOBD) PRTDEV(*JOBD) OUTQ(*JOBD) +
                          USER(&USER) INLLIBL(*JOBD) +
                          SCDTIME(&CLOCK) MSGQ(*NONE)
             ENDDO
END:
             ENDPGM
