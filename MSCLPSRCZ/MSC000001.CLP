/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas BIC Directory File Desc Initialise Control')    */
/*********************************************************************/
/*                                                                   */
/*       Midas - S.W.I.F.T Direct Link                               */
/*                                                                   */
/*       MSC000001  MIDAS BIC Directory File Desc Initialise Control */
/*                                                                   */
/*       (c) Finastra International Limited 2012                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. CMS002 *CREATE      Date 28Sep12             */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CMS002 - Midas BIC Details Enquiry                          */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&PRTCDE &PMODE)
 
             DCL        VAR(&PMODE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTCDE) TYPE(*CHAR) LEN(7)
 
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(ERROR ))
             CHGJOB     SWS(00000000)
 
/* Obtain a list of fields in file MEBICDPD                          */
 
             DSPFFD     FILE(MEBICDPD) OUTPUT(*OUTFILE) +
                          OUTFILE(QTEMP/MS000001PF)
 
/* Populate file MEBICFPD with the list of fields from file MEBICDPD */
 
             CPYF       FROMFILE(QTEMP/MS000001PF) TOFILE(MEBICFPD) +
                          MBROPT(*REPLACE) FMTOPT(*MAP *DROP)
 
/* Invoke the program to set sequence number field on MEBICFPD       */
 
             CALL       PGM(MS000001)
 
             IF         COND(%SWITCH(XXXXXXX1)) THEN(GOTO CMDLBL(ERROR))
 
/* Report on success                                                 */
 
             SNDPGMMSG  MSG('Initialisation Program ran successfully')
             GOTO ENDPGM
 
 ERROR:      SNDPGMMSG  MSG('Initialisation Program failed')
             CHGVAR     VAR(&PRTCDE) VALUE('*ERROR')
 
             DLTF       FILE(QTEMP/MS000001PF)
             MONMSG     MSGID(CPF0000)
 
 ENDPGM:     ENDPGM
