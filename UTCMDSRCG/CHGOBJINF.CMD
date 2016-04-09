/*STD    CMDBASE                                                     */
/*EXI    PGM(UTC000005)     VLDCKR(UTC000005V)    MSGF(UTMSGF)       */
/*EXI    HLPPNLGRP(CHGOBJINF)    HLPID(*CMD)                         */
/*EXI *  TEXT('Midas UT Change information about object')            */
/*********************************************************************/
/*                                                                   */
/*       Midas - Utilities Module                                    */
/*                                                                   */
/*       CHOBJINF - Change object information                        */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2008           */
/*                                                                   */
/*       Last Amend No. BUG27980           Date 05Aug10              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/*       Prev Amend No. BUG27133 *CREATE   Date 04Feb08              */
/*                      xxxxxx             Date ddMmmyy              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       BUG27980 - Remove DBGVIEW (Recompile).                      */
/*       BUG27133 - CHGOBJINF utility - delivery to core.            */
/*                                                                   */
/*********************************************************************/
             CMD        PROMPT('Change object information')
 
             PARM       KWD(OBJ) TYPE(QUAL1) MIN(1) PROMPT('Object' 1)
 QUAL1:      QUAL       TYPE(*NAME) LEN(10) MIN(1)
             QUAL       TYPE(*NAME) LEN(10) RSTD(*NO) MIN(1) +
                          PROMPT('Library')
 
             PARM       KWD(TYPE) TYPE(*CHAR) LEN(10) RSTD(*YES) +
                          VALUES(*ALRTBL *AUTL *BNDDIR *CFGL +
                          *CHTFMT *CLD *CLS *CMD *CNNL *COSD *CRG +
                          *CRQD *CSI *CSPMAP *CSPTBL *CTLD *DEVD +
                          *DOC *DTAARA *DTADCT *DTAQ *EDTD *EXITRG +
                          *FCT *FILE *FLR *FNTRSC *FNTTBL *FORMDF +
                          *FTR *GSS *IGCDCT *IGCSRT *IGCTBL *IMGCLG +
                          *IPXD *JOBD *JOBQ *JOBSCD *JRN *JRNRCV +
                          *LIB *LIND *LOCALE *MEDDFN *MENU *MGTCOL +
                          *MODD *MODULE *MSGF *MSGQ *M36 *M36CFG +
                          *NODGRP *NODL *NTBD *NWID *NWSD *OUTQ +
                          *OVL *PAGDFN *PAGSEG *PDFMAP *PDG *PGM +
                          *PNLGRP *PRDAVL *PRDDFN *PRDLOD *PSFCFG +
                          *QMFORM *QMQRY *QRYDFN *RCT *SBSD *SCHIDX +
                          *SPADCT *SQLPKG *SQLUDT *SRVPGM *SSND +
                          *SVRSTG *S36 *TBL *TIMZON *USRIDX *USRPRF +
                          *USRQ *USRSPC *VLDL *WSCST) MIN(1) +
                          PROMPT('Type' 2)
 
             PARM       KWD(SRCF) TYPE(*CHAR) LEN(10) DFT(*SAME) +
                          SPCVAL((*SAME)) PROMPT('Source file')
 
             PARM       KWD(SRCFLIB) TYPE(*CHAR) LEN(10) DFT(*SAME) +
                          SPCVAL((*SAME)) PROMPT('Source file library')
 
             PARM       KWD(SRCMBR) TYPE(*CHAR) LEN(10) DFT(*SAME) +
                          SPCVAL((*SAME)) PROMPT('Source member')
 
             PARM       KWD(SRCDATE) TYPE(*CHAR) LEN(13) DFT(*SAME) +
                          SPCVAL((*SAME)) CASE(*MIXED) +
                          PROMPT('Source file last change')
 
             PARM       KWD(COMPILER) TYPE(*CHAR) LEN(13) DFT(*SAME) +
                          SPCVAL((*SAME)) CASE(*MIXED) +
                          PROMPT('Compiler')
 
             PARM       KWD(OBJLVL) TYPE(*CHAR) LEN(8) DFT(*SAME) +
                          SPCVAL((*SAME)) CASE(*MIXED) +
                          PROMPT('Object control level')
 
             PARM       KWD(LICPGM) TYPE(*CHAR) LEN(13) DFT(*SAME) +
                          SPCVAL((*SAME)) CASE(*MIXED) +
                          PROMPT('Licensed program')
 
             PARM       KWD(PTF) TYPE(*CHAR) LEN(7) DFT(*SAME) +
                          SPCVAL((*SAME)) CASE(*MIXED) PROMPT('PTF')
 
             PARM       KWD(APAR) TYPE(*CHAR) LEN(6) DFT(*SAME) +
                          SPCVAL((*SAME)) CASE(*MIXED) +
                          PROMPT('Auth. pgm. analysis report')
 
             PARM       KWD(USRDFNATR) TYPE(*CHAR) LEN(10) +
                          DFT(*SAME) SPCVAL((*SAME)) CASE(*MIXED) +
                          PROMPT('User defined attribute')
 
             PARM       KWD(TEXT) TYPE(*CHAR) LEN(50) DFT(*SAME) +
                          SPCVAL((*SAME)) CASE(*MIXED) PROMPT('Text')
 
             PARM       KWD(USECOUNT) TYPE(*CHAR) LEN(6) RSTD(*YES) +
                          DFT(*SAME) VALUES(*SAME *RESET) +
                          PROMPT('Days used count')
 
             PARM       KWD(PRDOPTLDID) TYPE(*CHAR) LEN(4) +
                          DFT(*SAME) SPCVAL((*SAME *S)) +
                          CASE(*MIXED) PROMPT('Product option load ID')
 
             PARM       KWD(PRDOPTID) TYPE(*CHAR) LEN(4) DFT(*SAME) +
                          SPCVAL((*SAME *S)) CASE(*MIXED) +
                          PROMPT('Product option ID')
 
             PARM       KWD(CMPID) TYPE(*CHAR) LEN(4) DFT(*SAME) +
                          SPCVAL((*SAME *S)) CASE(*MIXED) +
                          PROMPT('Component ID')
 
             PARM       KWD(USEDATE) TYPE(*CHAR) LEN(6) RSTD(*YES) +
                          DFT(*SAME) VALUES(*SAME *RESET) +
                          PROMPT('Last used date')
 
             PARM       KWD(CHGDATE) TYPE(*CHAR) LEN(6) RSTD(*YES) +
                          DFT(*SAME) VALUES(*SAME *RESET) +
                          PROMPT('Date and time stamp')
 
             PARM       KWD(MBRUSECNT) TYPE(*CHAR) LEN(10) +
                          DFT(*SAME) SPCVAL((*SAME)) +
                          PROMPT('Member''s days used count')
