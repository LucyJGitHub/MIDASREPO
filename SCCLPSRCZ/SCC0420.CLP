/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas SC Start archive process')                      */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Standing Data Module                            */
/*                                                                   */
/*       SCC0420 - Submit Archive process if needed                  */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. CCB020             Date 06Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      CSC023             Date 02Feb04              */
/* Midas Release 4 --------------- Base -----------------------------*/
/*                      CPK014             Date 14Nov01              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      110242             Date 07NOV96              */
/*                      CSC001             DATE 04APR95              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CCB020 - COB Restructure - Secondary COB Infrastructure     */
/*       CSC023 - MidasPlus additional packaging.  SBMJOB change.    */
/*                OUTQ must always be *JOBD.                         */
/*       CPK014 - Submit jobs with user *JOBD                        */
/*       110242 - Change defaults for SBMJOB cmd to take *JOBD       */
/*       CSC001 - Move start to after ICIFINISH                      */
/*                                                                   */
/*********************************************************************/
             PGM
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7) VALUE(' ')
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7) VALUE('*FIRST ')
             DCL        VAR(&FMT) TYPE(*CHAR) LEN(200)
             DCL        VAR(&FICHE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&OPTDK) TYPE(*CHAR) LEN(1)
 
/* Global Monitor Message */
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) +
                           EXEC(GOTO ABNORMAL)
 
/**/
/* Access PF/SDMMODPD to determine which modules are live          */
/**/
             CALL       PGM(AOMMODR0) PARM(&RTCD &OPTN &FMT)
/**/
/* Database error                                                  */
/**/
             IF         COND(&RTCD *NE '       ') THEN(DO)
               SNDPGMMSG  MSG('Error on access to ICD file +
                            AOMMODPD') TOMSGQ(MOPERQ)
             GOTO       CMDLBL(ABNORMAL)
             ENDDO
/**/
/* Microfiche Module active = (&FMT 54) is 'Y'                     */
/* Optical Disk Module active = (&FMT 85) is 'Y'                   */
/**/
             CHGVAR     VAR(&FICHE) VALUE(%SST(&FMT 54 1))
             CHGVAR     VAR(&OPTDK) VALUE(%SST(&FMT 85 1))
/**/
/* MICROFICHE PROCESSING - to be performed only, if either         */
/* M-Fiche, or Opt-Disk modules are active                         */
/**/
             IF         COND((&FICHE *EQ 'Y') *OR (&OPTDK *EQ 'Y')) +
                          THEN(DO)
             CHGDTAARA  DTAARA(MACHK) VALUE('N')
/************SBMJOB     CMD(CALL PGM(MAC06)) JOB(ARCHIVE) +           /*110242*/
/*************            JOBD(MAJOBD) JOBQ(*JOBD) RTGDTA(*JOBD) +    /*110242*/
/*************            MSGQ(MOPERQ) */                             /*110242*/
/************SBMJOB     CMD(CALL PGM(MAC06)) JOB(ARCHIVE) +                               /*CPK014*/
/************             JOBD(MAJOBD) JOBQ(*JOBD) RTGDTA(*JOBD) +                        /*CPK014*/
/************             INLLIBL(*JOBD) MSGQ(MOPERQ)                 /*110242*/          /*CPK014*/
/************SBMJOB     CMD(CALL PGM(MAC06)) JOB(ARCHIVE) +                               /*CSC023*/
/************             JOBD(MAJOBD) JOBQ(*JOBD) USER(*JOBD) +                          /*CSC023*/
/************             RTGDTA(*JOBD) INLLIBL(*JOBD) MSGQ(MOPERQ)            /*CPK014*/ /*CSC023*/
/**********  SBMJOB     CMD(CALL PGM(MAC06)) JOB(ARCHIVE) +           */                  /*CCB020*/
/**********               JOBD(MAJOBD) JOBQ(*JOBD) USER(*JOBD) +      */                  /*CCB020*/
/**********               RTGDTA(*JOBD) INLLIBL(*JOBD) MSGQ(MOPERQ) + */                  /*CCB020*/
/**********               OUTQ(*JOBD)                                 */           /*CSC023 CCB020*/
             CALL       PGM(MAC06)                                                        /*CCB020*/
                                                                                          /*CCB020*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)                                  /*CCB020*/
             GOTO       CMDLBL(ABNORMAL)                                                  /*CCB020*/
             ENDDO                                                                        /*CCB020*/
             ENDDO
/* */
             GOTO       CMDLBL(ENDCLPGM)
/* */
/* Abnormal termination processing */
ABNORMAL:
             DMPCLPGM
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
             SNDPGMMSG  MSG('Program SCC0420 ended abnormally') +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          SCC0420 ended abnormally') MSGTYPE(*ESCAPE)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
/* End program */
 ENDCLPGM:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
