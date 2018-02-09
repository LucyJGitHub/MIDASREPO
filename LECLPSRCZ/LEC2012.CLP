/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas LE Start Loan Manager drip feed job')           */
/*********************************************************************/
/*                                                                   */
/*       Midas - Customer Lending Module                             */
/*                                                                   */
/*       LEC2012 - SUBMIT LOAN MANAGER INTERFACE DRIP FEED JOB       */
/*                                                                   */
/*       Function: To submit the Loan Manager Interface dripfeed     */
/*                 process LEC2016.                                  */
/*                                                                   */
/*       Calls:    None                                              */
/*                                                                   */
/*       (c) Finastra International Limited 2002                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CSC023             Date 29Jan04              */
/*                      216770             Date 10Apr03              */
/* Midas Release 4.01.02 --------------------------------------------*/
/*                      203561 *CREATE     Date 14Jun02              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CSC023 - MidasPlus additional packaging.  SBMJOB change.    */
/*                OUTQ must always be *JOBD.                         */
/*       216770 - Condition submission of dripfeed job on LM phase   */
/*                Component rewritten                                */
/*       203561 - Created as part of 203561.                         */
/*                                                                   */
/*********************************************************************/
             PGM
 
             DCL        VAR(&JOBTYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MESSAGE) TYPE(*CHAR) LEN(50)
             DCL        VAR(&DISABLED) TYPE(*CHAR) LEN(1) VALUE('N')                      /*216770*/
             DCL        VAR(&RESTRICTED) TYPE(*CHAR) LEN(1) VALUE('N')                    /*216770*/
             DCL        VAR(&LMDTAARA) TYPE(*CHAR) LEN(5)                                 /*216770*/
             DCL        VAR(&PREFIX) TYPE(*CHAR) LEN(2)                                   /*216770*/
             DCL        VAR(&DMLIB) TYPE(*CHAR) LEN(7)                                    /*216770*/
             DCL        VAR(&OWNER) TYPE(*CHAR) LEN(10)                                   /*216770*/
             DCL        VAR(&PHASE) TYPE(*CHAR) LEN(1)                                    /*216770*/
             DCL        VAR(&SERV) TYPE(*CHAR) LEN(3) VALUE(' ')                          /*216770*/
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)                                     /*216770*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7) VALUE('*FIRST')                     /*216770*/
             DCL        VAR(&#BRCD) TYPE(*CHAR) LEN(3)                                    /*216770*/
             DCL        VAR(&FMT)  TYPE(*CHAR) LEN(200)                                   /*216770*/
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(50)                                     /*216770*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2002')
 
/* Global Monitor Message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             SNDPGMMSG  MSG('LEC2012 - Start Loan Manager Drip Feed +
                          Job') TOMSGQ(MRUNQ)
 
             RTVJOBA    TYPE(&JOBTYPE)
             CHGJOB     SWS(00000000)
 
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&PREFIX)                              /*216770*/
                                                                                          /*216770*/
             CHGVAR     VAR(&DMLIB) VALUE(&PREFIX *CAT 'DMLIB')                           /*216770*/
                                                                                          /*216770*/
             RTVOBJD    OBJ(&DMLIB) OBJTYPE(*LIB) OWNER(&OWNER)                           /*216770*/
                                                                                          /*216770*/
 LOOP:                                                                                    /*216770*/
/**/                                                                                      /*216770*/
/*  Access PF/SDBRCHPD to retrieve MQ names */                                            /*216770*/
/**/                                                                                      /*216770*/
             CALL       PGM(AOBRCHR0) PARM(&RTCD &OPTN &#BRCD &FMT)                       /*216770*/
                                                                                          /*216770*/
             CHGVAR     VAR(&OPTN) VALUE('*NEXT')                                         /*216770*/
/**/                                                                                      /*216770*/
/*  Database error handling. */                                                           /*216770*/
/**/                                                                                      /*216770*/
             IF         COND(&RTCD *NE '       ') THEN(DO)                                /*216770*/
                IF       COND(&RTCD *EQ '*EOF') THEN(GOTO CMDLBL(NEXT))                   /*216770*/
                CHGVAR     VAR(&MSG) VALUE('Error on access to ICD  +
                             file SDBRCHPD')                                              /*216770*/
                GOTO       CMDLBL(ABNOR)                                                  /*216770*/
             ENDDO                                                                        /*216770*/
                                                                                          /*216770*/
             CHGVAR     VAR(&SERV) VALUE(%SST(&FMT 184 3))                                /*216770*/
                                                                                          /*216770*/
/* Only process live Loan Manager branches */                                             /*216770*/
                                                                                          /*216770*/
             IF         COND(&SERV *EQ ' ') THEN(GOTO CMDLBL(LOOP))                       /*216770*/
                                                                                          /*216770*/
             CHGVAR     VAR(&LMDTAARA) VALUE('LM' *CAT +
                          &SERV)
/**/                                                                                      /*216770*/
/** Check if LM Server Interface has been disabled                  */                    /*216770*/
/**/                                                                                      /*216770*/
             CALL       PGM(LEC2019) PARM(&SERV &DISABLED)                                /*216770*/
                                                                                          /*216770*/
             IF         COND(&DISABLED *NE 'Y') THEN(DO)                                  /*216770*/
                RTVDTAARA  DTAARA(&LMDTAARA (5 1)) RTNVAR(&PHASE)                         /*216770*/
/**/                                                                                      /*216770*/
/** Set restricted flag if LM server has status 'R'                 */                    /*216770*/
/**/                                                                                      /*216770*/
                IF         COND(&PHASE *EQ 'R') THEN(DO)                                  /*216770*/
                   CHGVAR     VAR(&RESTRICTED) VALUE('Y')                                 /*216770*/
                ENDDO                                                                     /*216770*/
             ENDDO                                                                        /*216770*/
NEXT:                                                                                     /*216770*/
/**/                                                                                      /*216770*/
/** Only submit batch job if none of LM servers is status 'R'        */                   /*216770*/
/**/                                                                                      /*216770*/
             IF         COND(&RESTRICTED *EQ 'N') THEN(DO)                                /*216770*/
             ALCOBJ     OBJ((LEDRIP *DTAARA *EXCL)) WAIT(0)
                                                                                          /*216770*/
/* If unable to allocate, job is already running */                                       /*216770*/
                                                                                          /*216770*/
             MONMSG     MSGID(CPF1002) EXEC(GOTO CMDLBL(END))
             DLCOBJ     OBJ((LEDRIP *DTAARA *EXCL))
 
/************SBMJOB     CMD(CALL PGM(LEC2016)) JOB(LEC2016) +                             /*CSC023*/
/************             JOBD(MBATCH) JOBQ(TSJOBQ) USER(*JOBD) +                         /*CSC023*/
/************             RTGDTA(PCLENDING) MSGQ(*NONE)                                   /*CSC023*/
 
             SBMJOB     CMD(CALL PGM(LEC2016)) JOB(LEC2016) +
                          JOBD(MBATCH) JOBQ(TSJOBQ) USER(*JOBD) +
                          RTGDTA(PCLENDING) MSGQ(*NONE) OUTQ(*JOBD)                       /*CSC023*/
 
/* Delay 5 seconds to allow submitted job to allocate the LEDRIP dtaara */
 
             DLYJOB     DLY(5)
             ENDDO                                                                        /*216770*/
 
             GOTO       CMDLBL(END)
 
/* Abnormal termination */
 
 ABNOR:
 
/* Abnormal termination - batch job */
 
             IF         COND(&JOBTYPE = '0') THEN(DO)
                CHGJOB     SWS(XXXXXX11)
                SNDPGMMSG  MSG('LEC2012 - Start Loan Manager drip +
                             feed job has ENDED ABNORMALLY') +
                             TOMSGQ(MOPERQ MRUNQ)
                MONMSG     MSGID(CPF0000 MCH0000)
             ENDDO
 
/* Abnormal termination - interactive job */
 
             IF         COND(&JOBTYPE = '1') THEN(DO)
                SNDPGMMSG  MSG('LEC2012 - Start Loan Manager drip +
                             feed job has ENDED ABNORMALLY') +
                             TOMSGQ(MOPERQ MRUNQ)
                MONMSG     MSGID(CPF0000 MCH0000)
 
/* Call SCC0010 to inform the user that an error has occurred */
 
                RTVMSG     MSGID(SCM0087) MSGF(GBMIDASMSG) MSG(&MESSAGE)
                MONMSG     MSGID(CPF0000 MCH0000)
 
                CHGDTAARA  DTAARA(MIDASMSG (251 50)) VALUE(&MESSAGE)
                MONMSG     MSGID(CPF0000 MCH0000)
 
                CALL       PGM(SCC0010) PARM('LEC2012' 'ENTER' ' ')
                MONMSG     MSGID(CPF0000 MCH0000)
             ENDDO
 
/* Normal termination */
 END:
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
