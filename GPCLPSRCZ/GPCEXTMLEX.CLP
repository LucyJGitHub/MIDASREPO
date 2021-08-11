/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas GP Extract ML Exposure')                        */
/*********************************************************************/
/*                                                                   */
/*       Midas - Global Processing Module                            */
/*                                                                   */
/*       GPCEXTMLEX - Extract ML Exposure                            */
/*                                                                   */
/*       (c) Finastra Systems Technology, Inc. 2019                  */
/*                                                                   */
/*       Last Amend No. DAI103             Date 25Jun19              */
/*       Prev Amend No. NADC01  *CREATE    Date 17Nov09              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       DAI103 - Upgraded MPlus 121 NADC01 ML Extracts to FB 2.1    */
/*       NADC01 - ML EXTRACTS FOR MIZUHO                             */
/*                                                                   */
/*********************************************************************/
             PGM
             DCLF       FILE(GZSDBANKL0)
 
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256)
             MONMSG     MSGID(CPF0000)
 
/* EXTRACT ML DETAILS */
             CLRPFM     FILE(TXMLTRNEXP)
             CLRPFM     FILE(TXUCAPTRAN)
             CALL       PGM(GPEXTMLDT)
 
/* EXTRACT ML EXPOSURE */
             CLRPFM     FILE(GPMLEXPD)
             CALL       PGM(GPEXTMLEX)
 
/* EXTRACT ML COUNTERPARTY EXPOSURE*/
             CLRPFM     FILE(GPMLXPPD)
             OVRDBF     FILE(T_MLLIMIT) TOFILE(T_MLLIMIT) +
                          OVRSCOPE(*JOB) SHARE(*YES) OPNSCOPE(*JOB)
             OPNQRYF    FILE((T_MLLIMIT)) KEYFLD((LIUTSRTYPE) +
                          (LIUTSRCODE) (LIINSTGRP))
             CALL       PGM(GPEXTMLXP) PARM('C')
             CLOF       OPNID(T_MLLIMIT)
             DLTOVR     FILE(T_MLLIMIT) LVL(*JOB)
 
             OVRDBF     FILE(T_MLLIMIT) TOFILE(T_MLLIMIT) +
                          OVRSCOPE(*JOB) SHARE(*YES) OPNSCOPE(*JOB)
             OPNQRYF    FILE((T_MLLIMIT)) KEYFLD((LIUTSRTYPE) +
                          (LIUTSRCODE) (LIINSTGRP))
             CALL       PGM(GPEXTMLXP) PARM('P')
             CLOF       OPNID(T_MLLIMIT)
             DLTOVR     FILE(T_MLLIMIT) LVL(*JOB)
 
/* REPORT ML UNCAPTURED TRANSACTIONS */
             CALL       PGM(GPRPTMLUT) PARM('C')
             CALL       PGM(GPRPTMLUT) PARM('P')
 
/*  EXTRACT ML COUNTRY EXPOSURE */
             CLRPFM     FILE(GPMLXCPD)
             OVRDBF     FILE(T_MLLIMIT) TOFILE(T_MLLIMIT) +
                          OVRSCOPE(*JOB) SHARE(*YES) OPNSCOPE(*JOB)
             OPNQRYF    FILE((T_MLLIMIT)) KEYFLD((LIUTSRTYPE) +
                          (LIUTSRCODE) (LIINSTGRP))
             CALL       PGM(GPEXTMLXC)
             CLOF       OPNID(T_MLLIMIT)
             DLTOVR     FILE(T_MLLIMIT) LVL(*JOB)
 
             CALL       PGM(GPEXTMLXD)
             CALL       PGM(GPEXTMLXE)
 
/*  REPORTS                     */
             RCVF
 
             CALL       PGM(GPRPTMLC)
             CALL       PGM(GPRPTMLP)
             CALL       PGM(GPRPTMLI)
             CALL       GPCCPYSPI PARM('GPRPTMLCP1' 'N' &BJMRDT)
             CALL       GPCCPYSPI PARM('GPRPTMLPP1' 'N' &BJMRDT)
             CALL       GPCCPYSPI PARM('GPRPTMLIP1' 'N' &BJMRDT)
 
             CALL       PGM(GPRPTMXC)
             CALL       PGM(GPRPTMXP)
             CALL       PGM(GPRPTMXI)
             CALL       GPCCPYSPI PARM('GPRPTMXCP1' 'N' &BJMRDT)
             CALL       GPCCPYSPI PARM('GPRPTMXPP1' 'N' &BJMRDT)
             CALL       GPCCPYSPI PARM('GPRPTMXIP1' 'N' &BJMRDT)
 
             CALL       PGM(GPRPTMZI)
             CALL       GPCCPYSPI PARM('GPRPTMZIP1' 'N' &BJMRDT)
 
             CLRPFM GPMLZCPD
             CLRPFM GPMLZPPD
             CALL       PGM(GPRPTMZC) PARM('N')
             CALL       PGM(GPRPTMZP) PARM('N')
             CALL       GPCCPYSPI PARM('GPRPTMZCP1' 'N' &BJMRDT)
             CALL       GPCCPYSPI PARM('GPRPTMZPP1' 'N' &BJMRDT)
 
             CALL       PGM(GPRPTMZC) PARM('Y')
             CALL       PGM(GPRPTMZP) PARM('Y')
             CALL       GPCCPYSPI PARM('GPRPTMZCP1' 'Y' &BJMRDT)
             CALL       GPCCPYSPI PARM('GPRPTMZPP1' 'Y' &BJMRDT)
 
             CALL       PGM(GPRPTMZS)
             CALL       GPCCPYSPI PARM('GPRPTMZSP1' 'N' &BJMRDT)
 
             CALL       PGM(GPRPTMZB)
             CALL       GPCCPYSPI PARM('GPRPTMZBP1' 'N' &BJMRDT)
             ENDPGM
