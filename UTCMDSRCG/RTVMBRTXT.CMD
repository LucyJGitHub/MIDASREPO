/*********************************************************************/
/*STD    CMDBASE                                                     */
/*EXI    PGM(UTC000023) VLDCKR(UTC000023V) MSGF(UTMSGF)              */
/*EXI    HLPPNLGRP(RTVMBRTXT) HLPID(*CMD)                            */
/*EXI    TEXT('Midas UT Retrieve member text from source')           */
/*********************************************************************/
/*                                                                   */
/*       Midas - Utilities                                           */
/*                                                                   */
/*       RTVMBRTXT - Retrieve member text from source                */
/*                                                                   */
/*       (c) Finastra International Limited 2015                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. CUP042             Date 27May15              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CUP042 - New utility                                        */
/*                                                                   */
/*********************************************************************/
             CMD        PROMPT('Retrieve member text from src.')
 
             PARM       KWD(SRC) TYPE(QUAL1) MIN(1) PROMPT('Source +
                          file')
 
             PARM       KWD(OVRTXT) TYPE(*CHAR) LEN(4) RSTD(*YES) DFT(*NO) +
                          VALUES(*NO *YES) MIN(0) PROMPT('Overwrite text?')
 
 QUAL1:      QUAL       TYPE(*GENERIC) LEN(10) SPCVAL((*ALL)) MIN(1)
             QUAL       TYPE(*NAME) LEN(10) PROMPT('Library')
 
 
