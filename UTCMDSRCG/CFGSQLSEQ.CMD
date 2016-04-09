/*********************************************************************/
/*STD    CMDBASE                                                     */
/*EXI    PGM(UTC000019) VLDCKR(UTC000019V) MSGF(UTMSGF)              */
/*EXI    HLPPNLGRP(CFGSQLSEQ) HLPID(*CMD)                            */
/*EXI    TEXT('Midas UT Configure SQL sequence (data area)')         */
/*********************************************************************/
/*                                                                   */
/*       Midas - Utilities Module                                    */
/*                                                                   */
/*       CFGSQLSEQ - Configure SQL sequence (data area)              */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2011           */
/*                                                                   */
/*       Last Amend No. AR663527 *CREATE   Date 10Jan11              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       AR663527 - RAT Transaction reference number should be a     */
/*                  daily incremental number (Child: AR663528)       */
/*                                                                   */
/*********************************************************************/
             CMD        PROMPT('Configure SQL sequence')
 
             PARM       KWD(SEQ) TYPE(QUAL1) MIN(1) PROMPT('Sequence +
                          (data area)' 1)
 QUAL1:      QUAL       TYPE(*NAME) LEN(10) MIN(1)
             QUAL       TYPE(*NAME) LEN(10) DFT(*LIBL) +
                          SPCVAL((*LIBL)) MIN(0) PROMPT('Library')
 
             PARM       KWD(RESTART) TYPE(*INT4) DFT(*SAME) +
                          RANGE(-999999 999999) SPCVAL((*SAME +
                          1000000)) MIN(0) PROMPT('Restart sequence +
                          ?' 2)
 
             PARM       KWD(INC) TYPE(*CHAR) LEN(5) RSTD(*YES) +
                          DFT(*SAME) VALUES(*SAME *YES) MIN(0) +
                          PROMPT('Change sequence increment ?' 3)
 
             PARM       KWD(CACHE) TYPE(*INT4) DFT(*SAME) RANGE(2 +
                          999999) SPCVAL((*SAME 0) (*NOCACHE 1)) +
                          MIN(0) PROMPT('Cache sequence numbers ?' 4)
 
             PARM       KWD(ORDER) TYPE(*CHAR) LEN(8) RSTD(*YES) +
                          DFT(*SAME) VALUES(*SAME *ORDER *NOORDER) +
                          MIN(0) PROMPT('Order seq. nos. by request +
                          ?' 5)
 
             PARM       KWD(MINVAL) TYPE(*INT4) DFT(*SAME) +
                          RANGE(-999999 999999) SPCVAL((*SAME +
                          1000000) (*NOMINVAL 1111111)) PROMPT('Set +
                          minimum value of seq. ?' 6)
 
             PARM       KWD(MAXVAL) TYPE(*INT4) DFT(*SAME) +
                          RANGE(-999999 999999) SPCVAL((*SAME +
                          1000000) (*NOMAXVAL 1111111)) PROMPT('Set +
                          maximum value of seq. ?' 7)
 
             PARM       KWD(CYCLE) TYPE(*CHAR) LEN(8) RSTD(*YES) +
                          DFT(*SAME) VALUES(*SAME *CYCLE *NOCYCLE) +
                          MIN(0) PMTCTL(*PMTRQS) PROMPT('Recycle +
                          sequence numbers ?' 8)
 
             PARM       KWD(INCBY) TYPE(INCBY) MIN(0) PMTCTL(PMT01) +
                          PROMPT('Increment by' 10)
 INCBY:      ELEM       TYPE(*INT2) DFT(1) RANGE(1 10) MIN(0) +
                          PROMPT('Number')
             ELEM       TYPE(*CHAR) LEN(8) RSTD(*YES) DFT(*ASCEND) +
                          VALUES(*ASCEND *DESCEND) MIN(0) +
                          PROMPT('Order')
 
 PMT01:      PMTCTL     CTL(INC) COND((*EQ *YES))
