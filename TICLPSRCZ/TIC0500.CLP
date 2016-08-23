/********************************************************************/
/*STD    CLPBASE                                                    */
/*EXI    TEXT('Midas TI Midas/TI interface cob control job (1st)')   */
/********************************************************************/
/*                                                                  */
/*       Midas/Trade Innovation Interface Module                    */
/*                                                                  */
/*       TIC0500 - TI COB Control Program                           */
/*                                                                  */
/*       Function : This program controls the early stages of the   */
/*                  TI Close of Business. It starts the TI phases   */
/*                  of COB and handles the response messages.       */
/*                                                                  */
/*                  This program can run in one of 2 modes.         */
/*          User -  The program is called by the TI COB Monitor     */
/*                  menu option (TI0500). User control is retained  */
/*                  when errors occur.                              */
/*          COB  -  The program runs in the Close of Business       */
/*                  and will handle all errors as they arise.       */
/*                                                                  */
/*       Calls :                                                    */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/*       Last Amend No. MD030956           Date 09Oct14              */
/*       Prev Amend No. MD029775B          Date 26Aug14             */
/*                      MD029775           Date 19Aug14             */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/*                      235616             Date 12Feb07             */
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4.01.02 --------------------------------------------*/
/*                      211144             Date 25Oct02             */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.05 ---------------------------------------------------*/
/*                      CTI003 *CREATE     Date 04Sep00             */
/*                                                                  */
/*------------------------------------------------------------------*/
/*                                                                  */
/*       MD030956 - Additional changes to BFM-TI enhancement.       */
/*                  No longer necessary as CTI006/7 is not dependent*/
/*                  on TI Module.                                   */
/*       MD029775B - TI/Midas EOD sync will no longer be used by TI */
/*                   Plus / TIC0500 still needed due to TIPOSTPD    */
/*       MD029775 - TI/Midas EOD sync will no longer be used by TI  */
/*                  Plus                                            */
/*       235616 - Move call to TIC1710B.                            */
/*              - Change the name of the TI Backup to comply with   */
/*                Midas System date before saving to tape.          */
/*       211144 - Needs to call KAPENEQ to receive message after    */
/*                KAPEQEN being called.                             */
/*                                                                  */
/********************************************************************/
             PGM        PARM(&PARM1 &PARM2 &PARM3 &PARM4 &PARM5)
 
/* Declarations */
             DCL        VAR(&PARM1) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PARM2) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PARM3) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PARM4) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PARM5) TYPE(*CHAR) LEN(1)
 
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(132)
             DCL        VAR(&JOBD) TYPE(*CHAR) LEN(26)
             DCL        VAR(&JOB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBR) TYPE(*CHAR) LEN(6)
             DCL        VAR(&AOTIIN) TYPE(*CHAR) LEN(200)
             DCL        VAR(&ACBB) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7) VALUE('*FIRST')
 
             DCL        VAR(&STS) TYPE(*CHAR) LEN(11)
             DCL        VAR(&BAT) TYPE(*CHAR) LEN(1)
             DCL        VAR(&BATC) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CLO) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CLOOK) TYPE(*CHAR) LEN(1)
             DCL        VAR(&EOL) TYPE(*CHAR) LEN(1)
             DCL        VAR(&EOLOK) TYPE(*CHAR) LEN(1)
             DCL        VAR(&SUS) TYPE(*CHAR) LEN(1)
             DCL        VAR(&SUSOK) TYPE(*CHAR) LEN(1)
             DCL        VAR(&STOPPROP) TYPE(*CHAR) LEN(1)
             DCL        VAR(&POSTINGS) TYPE(*CHAR) LEN(1)
             DCL        VAR(&EOD) TYPE(*CHAR) LEN(1)
             DCL        VAR(&SEND) TYPE(*CHAR) LEN(80)
             DCL        VAR(&LENGTH) TYPE(*DEC) LEN(5 0)
             DCL        VAR(&KEYWD) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MESGS) TYPE(*CHAR) LEN(10)
             DCL        VAR(&TI034N) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MPHAS) TYPE(*CHAR) LEN(1)
/**********  DCL        VAR(&SARD) TYPE(*CHAR) LEN(6)                */        /*MD029775 MD030956*/
/**********  DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7)                */        /*MD029775 MD030956*/
/**********  DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)                */        /*MD029775 MD030956*/
/**********  DCL        VAR(&FMT) TYPE(*CHAR) LEN(200)               */        /*MD029775 MD030956*/
/**********  DCL        VAR(&CTI007) TYPE(*CHAR) LEN(1)              */        /*MD029775 MD030956*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/*/COPY WNCPYSRC,TIH00016                                            */
 
             CHGJOB     SWS(XXXXXX00)
 
/* Global monitor message */
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/**Check*if*CTI007*is*installed**************************************/         /*MD029775 MD030956*/
/********************************************************************/         /*MD029775 MD030956*/
/**********  CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                 */         /*MD029775 MD030956*/
/**********  CHGVAR     VAR(&RTCD) VALUE('       ')                 */         /*MD029775 MD030956*/
/**********  CHGVAR     VAR(&SARD) VALUE('CTI007')                  */         /*MD029775 MD030956*/
/**********  CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SARD &FMT)  */         /*MD029775 MD030956*/
/********************************************************************/         /*MD029775 MD030956*/
/**********  CHGVAR     VAR(&CTI007) VALUE('N')                     */         /*MD029775 MD030956*/
/**********  IF         COND(&RTCD *EQ '       ') THEN(CHGVAR +     */         /*MD029775 MD030956*/
/**********               VAR(&CTI007) VALUE('Y'))                  */         /*MD029775 MD030956*/
/********************************************************************/         /*MD029775 MD030956*/
/**If*CTI007*is*installed,*do*not*run*this*component*****************/         /*MD029775 MD030956*/
/**********  IF         COND(&CTI007 *EQ 'N') THEN(GOTO +           */         /*MD029775 MD030956*/
/**********               CMDLBL(ENDP))                             */         /*MD029775 MD030956*/
/**********  IF         COND(&CTI007 *EQ 'Y') THEN(GOTO +           */        /*MD029775B MD030956*/
/**********               CMDLBL(ENDP))                             */        /*MD029775B MD030956*/
/* Confirm that this job isn't already running */
             ALCOBJ     OBJ((TIDTA *DTAARA *EXCLRD)) WAIT(5)
             MONMSG     MSGID(CPF1002) EXEC(DO)
                CHGVAR     VAR(&MSG) VALUE('TIC0500 - TI Control Job +
                       is already running')
                SNDPGMMSG  MSG(&MSG)
/* If this is being run during Input Cycle the end; otherwise end abnormally. */
                RTVDTAARA  DTAARA(MPHAS) RTNVAR(&MPHAS)
                IF         COND(&MPHAS *NE 'A') THEN(DO)
                   GOTO       CMDLBL(ABNOR)
                ENDDO
                ELSE       CMD(DO)
                   GOTO       CMDLBL(END)
                ENDDO
             ENDDO
 
/* Attempt to de-allocate data area TIDTA to prevent locking */
/* out CSCS.                                                 */
             DLCOBJ     OBJ((TIDTA *DTAARA *EXCLRD))
             MONMSG     MSGID(CPF0000)
 
 
/* Retrieve the Job Attributes and update TIDTA to contain them */
             RTVJOBA    JOB(&JOB) USER(&USER) NBR(&NBR)
 
             CHGDTAARA  DTAARA(TIDTA (101 10)) VALUE(&USER)
             CHGDTAARA  DTAARA(TIDTA (111 10)) VALUE(&JOB)
             CHGDTAARA  DTAARA(TIDTA (121 6)) VALUE(&NBR)
 
/* Call Midas/TI Interface ICD Access Object to check if Accruals */
/*  Check by Branch is on.                                        */
             CALL       PGM(AOTIINR0) PARM(&RTCD &OPTN &AOTIIN)
             IF         COND(&RTCD *NE '       ') THEN(GOTO +
                          CMDLBL(ABNOR))
             CHGVAR     VAR(&ACBB) VALUE(%SST(&AOTIIN 57 1))
 
/* Retrieve the data area flags for status of TI COB Phases */
             RTVDTAARA  DTAARA(TIDTA (51 11)) RTNVAR(&STS)
             CHGVAR     VAR(&BAT) VALUE(%SST(&STS 1 1))
             CHGVAR     VAR(&BATC) VALUE(%SST(&STS 2 1))
             CHGVAR     VAR(&CLO) VALUE(%SST(&STS 3 1))
             CHGVAR     VAR(&CLOOK) VALUE(%SST(&STS 4 1))
             CHGVAR     VAR(&EOL) VALUE(%SST(&STS 5 1))
             CHGVAR     VAR(&EOLOK) VALUE(%SST(&STS 6 1))
             CHGVAR     VAR(&SUS) VALUE(%SST(&STS 7 1))
             CHGVAR     VAR(&SUSOK) VALUE(%SST(&STS 8 1))
             CHGVAR     VAR(&STOPPROP) VALUE(%SST(&STS 9 1))
             CHGVAR     VAR(&POSTINGS) VALUE(%SST(&STS 10 1))
             CHGVAR     VAR(&EOD) VALUE(%SST(&STS 11 1))
 
/* Check data area whether 1of3 2of3, etc. processing is being used */
             RTVDTAARA  DTAARA(TIDTA (32 1)) RTNVAR(&TI034N)
 
/* Call TIC0050 to stop the Midas Batch Jobs  */
 CBAT:
             IF         COND((&BAT *EQ 'B') *OR (&BAT *EQ 'C')) +
                          THEN(DO)
                GOTO       CMDLBL(CBATC)
             ENDDO
             ELSE       CMD(DO)
 
/* If user requests bypass, then flag as bypassed and continue */
                IF         COND(&PARM1 *EQ 'B') THEN(DO)
                   CHGVAR     VAR(&PARM1) VALUE(' ')
                   CHGDTAARA  DTAARA(TIDTA (51 1)) VALUE('B')
                   GOTO       CMDLBL(CBATC)
                ENDDO
 
/* Update TIDTA to show 'Running' status and call program TIC0050 */
                CHGDTAARA  DTAARA(TIDTA (51 1)) VALUE('R')
 
                CALL       PGM(TIC0050) PARM('STOP')
                MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(DO)
 
/* Update TIDTA to reflect Batch process failed */
                   SNDPGMMSG  MSGID(TIM0020) MSGF(TIUSRMSG)
                   CHGDTAARA  DTAARA(TIDTA (51 1)) VALUE('F')
                   GOTO       CMDLBL(ABNOR)
                ENDDO
 
/* Update TIDTA to reflect Batch process completed successfully */
                CHGDTAARA  DTAARA(TIDTA (51 1)) VALUE('C')
 
             ENDDO
 
/* Call TIC0051 to Check Midas Batch Jobs have stopped */
 CBATC:
             IF         COND((&BATC *EQ 'B') *OR (&BATC *EQ 'C')) +
                          THEN(DO)
                GOTO       CMDLBL(CCLO)
             ENDDO
             ELSE       CMD(DO)
 
/* If user requests bypass, then flag as bypassed and continue */
                IF         COND(&PARM1 *EQ 'B') THEN(DO)
                   CHGVAR     VAR(&PARM1) VALUE(' ')
                   CHGDTAARA  DTAARA(TIDTA (52 1)) VALUE('B')
                   GOTO       CMDLBL(CCLO)
                ENDDO
 
/* Update TIDTA to show 'Running' status and call program TIC0051 */
                CHGDTAARA  DTAARA(TIDTA (52 1)) VALUE('R')
 
                CALL       PGM(TIC0051)
                MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(DO)
 
/* Update TIDTA to reflect TIC0051 failed */
                   SNDPGMMSG  MSGID(TIM0021) MSGF(TIUSRMSG)
                   CHGDTAARA  DTAARA(TIDTA (52 1)) VALUE('F')
                   GOTO       CMDLBL(ABNOR)
                ENDDO
 
/* Update TIDTA to reflect TIC0051 completed successfully */
                CHGDTAARA  DTAARA(TIDTA (52 1)) VALUE('C')
 
             ENDDO
 
/* Send CLOSING message */
 CCLO:
             IF         COND((&CLO *EQ 'B') *OR (&CLO *EQ 'C')) +
                          THEN(DO)
                GOTO       CMDLBL(CCLOOK)
             ENDDO
             ELSE       CMD(DO)
 
/* If user requests bypass, then flag as bypassed and continue */
                IF         COND(&PARM1 *EQ 'B') THEN(DO)
                   CHGVAR     VAR(&PARM1) VALUE(' ')
                   CHGDTAARA  DTAARA(TIDTA (53 1)) VALUE('B')
                   GOTO       CMDLBL(CCLOOK)
                ENDDO
 
/* Update TIDTA to show 'Running' status and call TI program KAPEQEN */
                CHGDTAARA  DTAARA(TIDTA (53 1)) VALUE('R')
 
/* Call KAPEQEN to send CLOSING message */
                CHGVAR     VAR(&LENGTH) VALUE(20)
                CHGVAR     VAR(&KEYWD) VALUE('*MODE     ')
                CHGVAR     VAR(&MESGS) VALUE('CLOSING')
                CHGVAR     VAR(&SEND) VALUE(&KEYWD *CAT &MESGS)
                SNDPGMMSG  MSGID(TIM0050) MSGF(TIUSRMSG)
                CALL       PGM(KAPEQEN) PARM(&SEND &LENGTH)
                MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(DO)
 
/* Update TIDTA to reflect CLOSING failed */
                   SNDPGMMSG  MSGID(TIM0022) MSGF(TIUSRMSG)
                   CHGDTAARA  DTAARA(TIDTA (53 1)) VALUE('F')
                   GOTO       CMDLBL(ABNOR)
 
                ENDDO
 
/* Update TIDTA to reflect CLOSING was successful */
                CHGDTAARA  DTAARA(TIDTA (53 1)) VALUE('C')
 
             ENDDO
 
 CCLOOK:
/* Decide which phase to start from */
             IF         COND((&CLOOK *EQ 'B') *OR (&CLOOK *EQ 'C')) +
                          THEN(DO)
                GOTO       CMDLBL(CEOL)
             ENDDO
             ELSE       CMD(DO)
 
/* If user requests bypass, then flag as bypassed and continue */
                IF         COND(&PARM1 *EQ 'B') THEN(DO)
                   CHGVAR     VAR(&PARM1) VALUE(' ')
                   CHGDTAARA  DTAARA(TIDTA (54 1)) VALUE('B')
                   GOTO       CMDLBL(CEOL)
                ENDDO
 
/* Update TIDTA to show 'Running' status and call TI program KAPENEQ */
                CHGDTAARA  DTAARA(TIDTA (54 1)) VALUE('R')
 
                CHGVAR     VAR(&LENGTH) VALUE(0)
                CHGVAR     VAR(&SEND) VALUE(' ')
                SNDPGMMSG  MSGID(TIM0051) MSGF(TIUSRMSG)
                CALL       PGM(KAPENEQ) PARM(&SEND &LENGTH)
 
/* If component times out then end. */
                IF         COND(&LENGTH *EQ 0) THEN(DO)
                   CHGDTAARA  DTAARA(TIDTA (54 1)) VALUE('T')
                   SNDPGMMSG  MSGID(TIM0024) MSGF(TIUSRMSG)
                   GOTO       CMDLBL(ABNOR)
                ENDDO
 
 /* If the return parameter is correct then continue */
                IF         COND((%SST(&SEND 11 10) *EQ 'CLOSINGOK') *OR +
                             (%SST(&SEND 11 10) *EQ 'RELEASEOK')) THEN(DO)
                   CHGDTAARA  DTAARA(TIDTA (54 1)) VALUE('C')
                   GOTO       CMDLBL(CEOL)
                ENDDO
                ELSE       CMD(DO)
 
                   SNDPGMMSG  MSGID(TIM0023) MSGF(TIUSRMSG)
                   CHGDTAARA  DTAARA(TIDTA (54 1)) VALUE('F')
                   GOTO       CMDLBL(ABNOR)
                ENDDO
 
             ENDDO
 
 CEOL:
/* Decide which phase to start from */
             IF         COND((&EOL *EQ 'B') *OR (&EOL *EQ 'C')) +
                          THEN(DO)
                GOTO       CMDLBL(CEOLOK)
             ENDDO
             ELSE       CMD(DO)
 
/* If user requests bypass, then flag as bypassed and continue */
                IF         COND(&PARM1 *EQ 'B') THEN(DO)
                   CHGVAR     VAR(&PARM1) VALUE(' ')
                   CHGDTAARA  DTAARA(TIDTA (55 1)) VALUE('B')
                   GOTO       CMDLBL(CEOLOK)
                ENDDO
 
/* Update TIDTA to show 'Running' status and call TI program KAPEQEN */
                CHGDTAARA  DTAARA(TIDTA (55 1)) VALUE('R')
 
                CHGVAR     VAR(&LENGTH) VALUE(20)
                CHGVAR     VAR(&KEYWD) VALUE('*BATCH    ')
                CHGVAR     VAR(&MESGS) VALUE('STREONL')
                CHGVAR     VAR(&SEND) VALUE(&KEYWD *CAT &MESGS)
                SNDPGMMSG  MSGID(TIM0052) MSGF(TIUSRMSG)
                CALL       PGM(KAPEQEN) PARM(&SEND &LENGTH)
                MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(DO)
 
/* Update TIDTA to reflect STREONL failed */
                   SNDPGMMSG  MSGID(TIM0025) MSGF(TIUSRMSG)
                   CHGDTAARA  DTAARA(TIDTA (55 1)) VALUE('F')
                   GOTO       CMDLBL(ABNOR)
 
                ENDDO
 
/* Update TIDTA to reflect ENDEONL was successful */
                CHGDTAARA  DTAARA(TIDTA (55 1)) VALUE('C')
 
             ENDDO
 
 CEOLOK:
/* Decide which phase to start from */
             IF         COND((&EOLOK *EQ 'B') *OR (&EOLOK *EQ 'C')) +
                          THEN(DO)
                GOTO       CMDLBL(CSUS)
             ENDDO
             ELSE       CMD(DO)
 
/* If user requests bypass, then flag as bypassed and continue */
                IF         COND(&PARM1 *EQ 'B') THEN(DO)
                   CHGVAR     VAR(&PARM1) VALUE(' ')
                   CHGDTAARA  DTAARA(TIDTA (56 1)) VALUE('B')
                   GOTO       CMDLBL(CSUS)
                ENDDO
 
/* Update TIDTA to show 'Running' status and call TI program KAPENEQ */
                CHGDTAARA  DTAARA(TIDTA (56 1)) VALUE('R')
 
                CHGVAR     VAR(&LENGTH) VALUE(0)
                CHGVAR     VAR(&SEND) VALUE(' ')
                SNDPGMMSG  MSGID(TIM0053) MSGF(TIUSRMSG)
                CALL       PGM(KAPENEQ) PARM(&SEND &LENGTH)
 
/* If component times out then end. */
                IF         COND(&LENGTH *EQ 0) THEN(DO)
                   CHGDTAARA  DTAARA(TIDTA (56 1)) VALUE('T')
                   SNDPGMMSG  MSGID(TIM0027) MSGF(TIUSRMSG)
                   GOTO       CMDLBL(ABNOR)
                ENDDO
 
 /* If the return parameter shows failure then end */
                IF         COND(%SST(&SEND 11 10) *EQ 'STREONLFAIL') +
                          THEN(DO)
                   CHGDTAARA  DTAARA(TIDTA (56 1)) VALUE('F')
                   SNDPGMMSG  MSGID(TIM0028) MSGF(TIUSRMSG)
                   GOTO       CMDLBL(ABNOR)
                ENDDO
 
 /* If the return parameter is correct then continue */
                IF         COND(%SST(&SEND 11 10) *EQ 'STREONLOK') +
                             THEN(DO)
                   CHGDTAARA  DTAARA(TIDTA (56 1)) VALUE('C')
                   GOTO       CMDLBL(CSUS)
                ENDDO
                ELSE       CMD(DO)
 
                   SNDPGMMSG  MSGID(TIM0026) MSGF(TIUSRMSG)
                   CHGDTAARA  DTAARA(TIDTA (56 1)) VALUE('F')
                   GOTO       CMDLBL(ABNOR)
                ENDDO
 
             ENDDO
 
 CSUS:
/* Decide which phase to start from */
             IF         COND((&SUS *EQ 'B') *OR (&SUS *EQ 'C')) +
                          THEN(DO)
                GOTO       CMDLBL(CSUSOK)
             ENDDO
             ELSE       CMD(DO)
 
/* If user requests bypass, then flag as bypassed and continue */
                IF         COND(&PARM1 *EQ 'B') THEN(DO)
                   CHGVAR     VAR(&PARM1) VALUE(' ')
                   CHGDTAARA  DTAARA(TIDTA (57 1)) VALUE('B')
                   GOTO       CMDLBL(CSUSOK)
                ENDDO
 
/* Update TIDTA to show 'Running' status and call TI program KAPEQEN */
                CHGDTAARA  DTAARA(TIDTA (57 1)) VALUE('R')
 
                CHGVAR     VAR(&LENGTH) VALUE(20)
                CHGVAR     VAR(&KEYWD) VALUE('*MODE     ')
                CHGVAR     VAR(&MESGS) VALUE('SUSPEND')
                CHGVAR     VAR(&SEND) VALUE(&KEYWD *CAT &MESGS)
                SNDPGMMSG  MSGID(TIM0054) MSGF(TIUSRMSG)
                CALL       PGM(KAPEQEN) PARM(&SEND &LENGTH)
                MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(DO)
 
/* Update TIDTA to reflect SUSPEND failed */
                   SNDPGMMSG  MSGID(TIM0029) MSGF(TIUSRMSG)
                   CHGDTAARA  DTAARA(TIDTA (57 1)) VALUE('F')
                   GOTO       CMDLBL(ABNOR)
 
                ENDDO
 
/* Update TIDTA to reflect SUSPEND was successful */
                CHGDTAARA  DTAARA(TIDTA (57 1)) VALUE('C')
 
             ENDDO
 
 CSUSOK:
/* Decide which phase to start from */
             IF         COND((&SUSOK *EQ 'B') *OR (&SUSOK *EQ 'C')) +
                          THEN(DO)
                GOTO       CMDLBL(CSTOPPROP)
             ENDDO
             ELSE       CMD(DO)
 
/* If user requests bypass, then flag as bypassed and continue */
                IF         COND(&PARM1 *EQ 'B') THEN(DO)
                   CHGVAR     VAR(&PARM1) VALUE(' ')
                   CHGDTAARA  DTAARA(TIDTA (58 1)) VALUE('B')
                   GOTO       CMDLBL(CPOSTINGS)
                ENDDO
 
/* Update TIDTA to show 'Running' status and call TI program KAPENEQ */
                CHGDTAARA  DTAARA(TIDTA (58 1)) VALUE('R')
 
                CHGVAR     VAR(&LENGTH) VALUE(0)
                CHGVAR     VAR(&SEND) VALUE(' ')
                SNDPGMMSG  MSGID(TIM0055) MSGF(TIUSRMSG)
                CALL       PGM(KAPENEQ) PARM(&SEND &LENGTH)
 
/* If component times out, flag the send of SUSPEND as Failed so */
/*  that SUSPEND will be re-sent when TIC0500 is restarted.      */
                IF         COND(&LENGTH *EQ 0) THEN(DO)
                      CHGDTAARA  DTAARA(TIDTA (58 1)) VALUE('T')
                      CHGDTAARA  DTAARA(TIDTA (57 1)) VALUE('F')
                      SNDPGMMSG  MSGID(TIM0031) MSGF(TIUSRMSG)
                      GOTO       CMDLBL(ABNOR)
                ENDDO
 
 /* If the return parameter is correct then continue */
                IF         COND(%SST(&SEND 11 10) *EQ 'SUSPENDOK') +
                             THEN(DO)
                   CHGDTAARA  DTAARA(TIDTA (58 1)) VALUE('C')
                   GOTO       CMDLBL(CSTOPPROP)
                ENDDO
                ELSE       CMD(DO)
 
/* If component fails, flag the send of SUSPEND as Failed so     */
/*  that SUSPEND will be re-sent when TIC0500 is restarted.      */
                   SNDPGMMSG  MSGID(TIM0030) MSGF(TIUSRMSG)
                   CHGDTAARA  DTAARA(TIDTA (58 1)) VALUE('F')
                   CHGDTAARA  DTAARA(TIDTA (57 1)) VALUE('F')
                   GOTO       CMDLBL(ABNOR)
                ENDDO
 
             ENDDO
 
 CSTOPPROP:
/* Decide which phase to start from */
             IF         COND((&STOPPROP *EQ 'B') *OR (&STOPPROP *EQ +
                          'C')) THEN(DO)
                GOTO       CMDLBL(CPOSTINGS)
             ENDDO
             ELSE       CMD(DO)
 
/* If user requests bypass, then flag as bypassed and continue */
                IF         COND(&PARM1 *EQ 'B') THEN(DO)
                   CHGVAR     VAR(&PARM1) VALUE(' ')
                   CHGDTAARA  DTAARA(TIDTA (59 1)) VALUE('B')
                   GOTO       CMDLBL(CPOSTINGS)
                ENDDO
 
/* Update TIDTA to show 'Running' status and call TI program KAPEQEN */
                CHGDTAARA  DTAARA(TIDTA (59 1)) VALUE('R')
 
                CHGVAR     VAR(&LENGTH) VALUE(20)
                CHGVAR     VAR(&SEND) VALUE('*PROP     STOP')
                SNDPGMMSG  MSGID(TIM0067) MSGF(TIUSRMSG)
                CALL       PGM(KAPEQEN) PARM(&SEND &LENGTH)
                MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(DO)
 
/* Update TIDTA to reflect that attempt to stop Prop. Job failed */
                   CHGDTAARA  DTAARA(TIDTA (59 1)) VALUE('F')
                   SNDPGMMSG  MSGID(TIM0068) MSGF(TIUSRMSG)
                   GOTO       CMDLBL(ABNOR)
 
                ENDDO
                                                                                          /*211144*/
/* Call TI program KAPENEQ to receive message */                                          /*211144*/
                                                                                          /*211144*/
                CHGVAR     VAR(&LENGTH) VALUE(0)                                          /*211144*/
                CHGVAR     VAR(&SEND) VALUE(' ')                                          /*211144*/
                SNDPGMMSG  MSGID(TIM0080) MSGF(TIUSRMSG)                                  /*211144*/
                CALL       PGM(KAPENEQ) PARM(&SEND &LENGTH)                               /*211144*/
                                                                                          /*211144*/
/* If &SEND is not 'STOPPED' or &LENGTH is zero then error */                             /*211144*/
                                                                                          /*211144*/
                IF         COND((%SST(&SEND 11 10) *NE 'STOPPED') *OR +
                             (&LENGTH *EQ 0)) THEN(DO)                                    /*211144*/
                   CHGDTAARA  DTAARA(TIDTA (59 1)) VALUE('F')                             /*211144*/
                   SNDPGMMSG  MSGID(TIM0081) MSGF(TIUSRMSG)                               /*211144*/
                   GOTO       CMDLBL(ABNOR)                                               /*211144*/
                ENDDO                                                                     /*211144*/
                                                                                          /*211144*/
 
/* Update TIDTA to reflect Stop of Prop. job successful */
                CHGDTAARA  DTAARA(TIDTA (59 1)) VALUE('C')
 
             ENDDO
 CPOSTINGS:
/* Decide which phase to start from */
             IF         COND((&POSTINGS *EQ 'B') *OR (&POSTINGS *EQ 'C')) +
                          THEN(DO)
                GOTO       CMDLBL(CEOD)
             ENDDO
             ELSE       CMD(DO)
 
/* If user requests bypass, then flag as bypassed and continue */
                IF         COND(&PARM1 *EQ 'B') THEN(DO)
                   CHGVAR     VAR(&PARM1) VALUE(' ')
                   CHGDTAARA  DTAARA(TIDTA (60 1)) VALUE('B')
                   GOTO       CMDLBL(CEOD)
                ENDDO
 
/* Update TIDTA to show 'Running' status and call program TI0340 or TI0341 */
                CHGDTAARA  DTAARA(TIDTA (60 1)) VALUE('R')
 
   /* Call program for final process of any outstanding TI postings. */
                CHGDTAARA  DTAARA(TI0340 (1 5)) VALUE('STOP ')
                CALL       PGM(TIC0340) PARM(' ' ' ' ' ' ' ' ' ')
                IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                   CHGDTAARA  DTAARA(TIDTA (60 1)) VALUE('F')
                   GOTO       CMDLBL(ABNOR)
                ENDDO
/* Call program to check accruals if Accruals check by Branch is flagged on ICD. */
                IF         COND(&ACBB *EQ 'Y') THEN(DO)
                   IF         COND(&POSTINGS *EQ 'P') THEN(DO)
                      CALL       PGM(TI0507)
                      IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                         CHGDTAARA  DTAARA(TIDTA (60 1)) VALUE('F')
                         GOTO       CMDLBL(ABNOR)
                      ENDDO
                   ENDDO
                   ELSE       CMD(DO)
   /* If this is the second attempt, flag as completed and continue */
                      CALL       PGM(TI0507)
                      CHGJOB     SWS(XXXXXX00)
                   ENDDO
                ENDDO
   /* Call program to process accruals. */
             CALL       PGM(TIC0342)
                IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                   CHGDTAARA  DTAARA(TIDTA (60 1)) VALUE('F')
                   GOTO       CMDLBL(ABNOR)
                ENDDO
 
/* Update TIDTA to reflect postings processing was successful. */
                CHGDTAARA  DTAARA(TIDTA (60 1)) VALUE('C')
 
             ENDDO
 CEOD:
/* Decide which phase to start from */
             IF         COND((&EOD *EQ 'B') *OR (&EOD *EQ 'C')) +
                          THEN(DO)
                GOTO       CMDLBL(END)
             ENDDO
             ELSE       CMD(DO)
 
/* If user requests bypass, then flag as bypassed and continue */
                IF         COND(&PARM1 *EQ 'B') THEN(DO)
                   CHGVAR     VAR(&PARM1) VALUE(' ')
                   CHGDTAARA  DTAARA(TIDTA (61 1)) VALUE('B')
                   GOTO       CMDLBL(END)
                ENDDO
 
/* Update TIDTA to show 'Running' status and call TI program KAPEQEN */
                CHGDTAARA  DTAARA(TIDTA (61 1)) VALUE('R')
 
                CHGVAR     VAR(&LENGTH) VALUE(20)
                CHGVAR     VAR(&KEYWD) VALUE('*BATCH    ')
                CHGVAR     VAR(&MESGS) VALUE('STREOD')
                CHGVAR     VAR(&SEND) VALUE(&KEYWD *CAT &MESGS)
                SNDPGMMSG  MSGID(TIM0056) MSGF(TIUSRMSG)
                CALL       PGM(KAPEQEN) PARM(&SEND &LENGTH)
                MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(DO)
 
/* Update TIDTA to reflect STREOD failed */
                   CHGDTAARA  DTAARA(TIDTA (61 1)) VALUE('F')
                   SNDPGMMSG  MSGID(TIM0032) MSGF(TIUSRMSG)
                   GOTO       CMDLBL(ABNOR)
 
                ENDDO
 
/* Update TIDTA to reflect STREOD was successful */
                CHGDTAARA  DTAARA(TIDTA (61 1)) VALUE('C')
                GOTO       CMDLBL(END)
 
             ENDDO
 
/* Abnormal termination  */
 ABNOR:
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000)
             CHGVAR     VAR(&MSG) VALUE('TIC0500 - TI COB Control +
                          Job ended abnormally')
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA(&MSG) +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 MCH0000)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA(&MSG)
             MONMSG     MSGID(CPF0000 MCH0000)
 
 
 END:
/**/                                                                                      /*235616*/
/* Check and update the filename of the TI Backup.  */                                    /*235616*/
/**/                                                                                      /*235616*/
/*/COPY WNCPYSRC,TIH00017                                            */
             CALL       PGM(TIC1710B) PARM('TIBACKUPS')                                   /*235616*/
             CHGVAR     VAR(&JOBD) VALUE('          ')
 
/* If this job has run, update the data area to show it is not */
/* currently active */
             IF         COND(&STS *NE ' ') THEN(DO)
                CHGDTAARA  DTAARA(TIDTA (101 26)) VALUE(&JOBD)
                MONMSG     MSGID(CPF0000)
                DLCOBJ     OBJ((TIDTA *DTAARA *EXCLRD))
                MONMSG     MSGID(CPF0000)
             ENDDO
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
                                                                                        /*MD029775*/
 ENDP:                                                                                  /*MD029775*/
             ENDPGM
