/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SC Check if trigger active on file')            */
/*********************************************************************/
/*                                                                   */
/*       Midas - System Control Module                               */
/*                                                                   */
/*       SCCHKTRIG - Check if trigger active on file                 */
/*                                                                   */
/*       (c) Finastra International Limited 2003                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. BG5090R            Date 18Feb05              */
/*                      CGP001  *CREATE    Date 23May03              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       BG5090R - Remove sequence number processing                 */
/*       CGP001 - Global Processing                                  */
/*                                                                   */
/*********************************************************************/
/************PGM        PARM(&FILE &TRTM &TREV &TSEQ &TRGACT &TRGCNT)                    /*BG5090R*/
             PGM        PARM(&FILE &TNAM &TRGACT)                                        /*BG5090R*/
 
             DCL        VAR(&FILE) TYPE(*CHAR) LEN(10)
/************DCL        VAR(&TRTM) TYPE(*CHAR) LEN(1)                                    /*BG5090R*/
/************DCL        VAR(&TREV) TYPE(*CHAR) LEN(1)                                    /*BG5090R*/
/************DCL        VAR(&TSEQ) TYPE(*CHAR) LEN(2)                                    /*BG5090R*/
 
/************DCL        VAR(&SYPR) TYPE(*CHAR) LEN(2)                                    /*BG5090R*/
             DCL        VAR(&TNAM) TYPE(*CHAR) LEN(258)
 
             DCL        VAR(&TRGACT) TYPE(*CHAR) LEN(1)
             DCL        VAR(&TRGCNT) TYPE(*DEC)  LEN(2 0)
 
             DCL        VAR(&JOBTYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2003')
 
             DCLF       FILE(QAFDTRG)
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             RTVJOBA    TYPE(&JOBTYPE)
             CHGJOB     SWS(00000000)
 
/************RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&SYPR)                               /*BG5090R*/
 
/************CHGVAR     VAR(&TNAM) VALUE(&SYPR *CAT '_' *CAT +                           /*BG5090R*/
/************             &FILE *TCAT '_' *CAT &TRTM *CAT +                              /*BG5090R*/
/************             '_' *CAT &TREV *CAT '_' *CAT &TSEQ)                            /*BG5090R*/
 
             DSPFD      FILE(&FILE) TYPE(*TRG) OUTPUT(*OUTFILE) +
                          OUTFILE(QTEMP/TRIGGERS)
             OVRDBF     FILE(QAFDTRG) TOFILE(QTEMP/TRIGGERS)
 
             CHGVAR     VAR(&TRGACT) VALUE('N')
             CHGVAR     VAR(&TRGCNT) VALUE(0)
 
AGAIN:
             RCVF
             MONMSG     MSGID(CPF0864) EXEC(GOTO CMDLBL(END))                            /*BG5090R*/
/************MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(END))                            /*BG5090R*/
 
             CHGVAR     VAR(&TRGCNT) VALUE(&TRGCNT + 1)
 
/************IF         COND((&TRTRTM = &TRTM) *AND (&TRTREV = +                         /*BG5090R*/
/************             &TREV) *AND (&TRTRIG = 'SCTRIGGER') *AND +                     /*BG5090R*/
/************             (&TRNAM = &TNAM)) THEN(DO)                                     /*BG5090R*/
             IF         COND((&TRTRIG = 'SCTRIGGER') *AND (&TRNAM = +
                          &TNAM)) THEN(DO)                                               /*BG5090R*/
               CHGVAR     VAR(&TRGACT) VALUE('Y')
               GOTO       CMDLBL(END)
             ENDDO
 
             GOTO       CMDLBL(AGAIN)
 
 ABNOR:
             CHGJOB     SWS(XXXXXX11)
 
/* Abnormal termination - batch job */
 
             IF         COND(&JOBTYPE = '0') THEN(DO)
               SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            SCCHKTRIG ended abnormally - see job log') +
                            TOMSGQ(MOPERQ MRUNQ)
               MONMSG     MSGID(CPF0000 MCH0000)
             ENDDO
 
/* Abnormal termination - interactive job */
 
             IF         COND(&JOBTYPE = '1') THEN(DO)
/************   SNDPGMMSG  MSGID(MEM5003) MSGF(MIDAS) +                                  /*BG5090R*/
/************             TOPGMQ(*EXT) TOMSGQ(MOPERQ)                                    /*BG5090R*/
                SNDPGMMSG  MSGID(MEM5007) MSGF(MIDAS) MSGTYPE(*ESCAPE)                   /*BG5090R*/
                MONMSG     MSGID(CPF0000 MCH0000)
             ENDDO
 
END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
