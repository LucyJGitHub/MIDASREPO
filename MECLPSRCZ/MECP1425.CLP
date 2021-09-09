/*********************************************************************/
/*STD    CLPBASE                                                     */
/*********************************************************************/
/*                                                                   */
/*       Midas - Message Management                                  */
/*                                                                   */
/*       MECP1425 -  BIC Plus loader  COB                            */
/*                                                                   */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/*       Last Amend No. MD31937            Date 13Jan15              */
/*       Last Amend No. AR856737           Date 13Sep11              */
/*       Last Amend No. ESL044             Date 01Feb2005            */
/* Midas Release 4 --------------- Base -----------------------------*/
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD31937  - Upgrade STP enhancements to BF Midas 2.1         */
/*       AR856737 - Upgrade STP enhancements to Midas Plus level     */
/*       ESL044 - BIC Load for COB                                   */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&COMP_NAME &COMP_SEQ)

/* Copyright statement                                               */
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/* */
/* Declare variables */
/* */
             DCL        VAR(&RTN_CODE) TYPE(*CHAR) LEN(7)
             DCL        VAR(&COMP_NAME) TYPE(*CHAR) LEN(10)
             DCL        VAR(&COMP_SEQ) TYPE(*DEC) LEN(5)
             DCL        VAR(&STATUS) TYPE(*CHAR) LEN(1)
             DCL        VAR(&DATA) TYPE(*CHAR) LEN(50)

             DCL        VAR(&REL_DAT) TYPE(*CHAR) LEN(8)
             DCL        VAR(&RET_COD) TYPE(*CHAR) LEN(7)

             DCL        VAR(&DMLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&DPLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&DILIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&DBPREFIX) TYPE(*CHAR) LEN(2)

/*/COPY WNCPYSRC,MEC1425DB3                                          */

/* Global Monitor Message                                            */
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) +
                           EXEC(GOTO ENDCLPGM)
             CHGJOB     SWS(XXXXX000)
/* */
/* Format DILIB name */
/* */
             RTVOBJD    OBJ(DBIC) OBJTYPE(*FILE) RTNLIB(&DILIB)
/* */
/* Format DMLIB name */
/* */
             RTVOBJD    OBJ(MEBICDPD) OBJTYPE(*FILE) RTNLIB(&DMLIB)
/* */
/* Format DPLIB name */
/* */
             RTVOBJD    OBJ(METICPPD) OBJTYPE(*FILE) RTNLIB(&DPLIB)
/* */
/* Get run status */
/* */
             CHGVAR     VAR(&STATUS) VALUE(' ')
             CALL       PGM(CB0160) PARM(&COMP_NAME &COMP_SEQ &STATUS)
/* */
/* If status is active - Perform recovery */
/* */
             IF         COND((&STATUS *NE 'N') *AND +
                             (&STATUS *NE 's')) THEN(DO)
/* */
/* Restore BIC Directory Files from MEBICSAVF */
/* */
             RSTOBJ     OBJ(MEBICPPD MEBICCPD MEBICIPD MEBICDPD) +
                          SAVLIB(&DMLIB) DEV(*SAVF) +
                          SAVF(&DILIB/MEBICSAVF)
/* */
             ENDDO
             ELSE       CMD(DO)
/* */
/* Delete and Create Save file MEBICSAVF */
/* */
             DLTF       FILE(&DILIB/MEBICSAVF)
             MONMSG     MSGID(CPF2105)
/* */
             CRTSAVF    FILE(&DILIB/MEBICSAVF) TEXT('Save file for +
                          BIC Directory Load Processing')
/* */
/* Save BIC Directory to MEBICSAVF */
/* */
             SAVOBJ     OBJ(MEBICPPD MEBICCPD MEBICIPD MEBICDPD) +
                          LIB(&DMLIB) DEV(*SAVF) +
                          SAVF(&DILIB/MEBICSAVF) USEOPTBLK(*NO)
/* */
             ENDDO
/* */
/* Update status to Active */
/* */
             CHGVAR     VAR(&STATUS) VALUE('Y')
             CALL       PGM(CB0150) PARM(&COMP_NAME &COMP_SEQ &STATUS)
/* */
/* Start Commitment Control */
/* */
             STRCMTCTL  LCKLVL(*CHG) NFYOBJ(MNTYF (*FILE)) +
                          CMTSCOPE(*JOB)
             MONMSG     MSGID(CPF8351)

/*/COPY WNCPYSRC,MEC1425DB2                                         */
/* Call the BIC version reader                                       */
             CALL       PGM(MEC1421) PARM(&REL_DAT)

             IF         COND(&REL_DAT *EQ ' ') THEN(DO)
    /* No Data has been read from the S.W.I.F.T release date table   */

             SNDPGMMSG  MSG('No data to extract for SWIFT BIC load') +
                          TOMSGQ(MOPERQ MRUNQ)

             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)

             GOTO       CMDLBL(ENDCLPGM)

             ENDDO

/* Update BIC Database Plus table                                    */
             CPYF       FROMFILE(METICPPD) TOFILE(MEBICPPD) +
                          MBROPT(*REPLACE) INCREL((*IF BIFLAG *NE 'D'))

/* Update BIC Country table                                          */
             CPYF       FROMFILE(METICCPD) TOFILE(MEBICCPD) +
                          MBROPT(*REPLACE)

/* Update BIC Database Plus Search Index                             */

             CLRPFM     FILE(MEBICIPD)

/*    Call the BIC Plus search index creation program                */
             CALL       PGM(ME1430) PARM(&RET_COD)

/* Update BIC Directory                                              */

             CLRPFM     FILE(MEBICDPD)
/*    Call the BIC Directory update program                          */
             CALL       ME1440

/* Clear temporary files                                             */
/*/COPY WNCPYSRC,MEC1425DB1                                          */

/* */
/* Update status to Not Active - component finished */
/* */
             CHGVAR     VAR(&STATUS) VALUE('s')
             CALL       PGM(CB0150) PARM(&COMP_NAME &COMP_SEQ &STATUS)
             CLRPFM     METICPPD
             CLRPFM     METICCPD
             CLRPFM     METICVPD

/**/
             GOTO       CMDLBL(ENDCLPGM)
/* */
/* Report Database errors trapped by program */
/* */
 DBERR:
             RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&DATA)
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&DATA) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)
/**/
/* Abnormal termination processing                       */
/**/
ABNORMAL:
             ROLLBACK
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             DMPCLPGM
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
             SNDPGMMSG  MSG('Program MECP1425 ended abnormally') +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          MECP1425 ended abnormally') MSGTYPE(*ESCAPE)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 ENDCLPGM:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)


             ENDPGM
