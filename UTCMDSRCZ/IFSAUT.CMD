/*********************************************************************/
/*STD    CMDBASE                                                     */
/*EXI    PGM(IFSAUTLC)      VLDCKR(*NONE)      MSGF(QCPFMSG)         */
/*EXI    HLPPNLGRP(IFSAUTLC)     HLPID(*CMD)                         */
/*EXI *  TEXT('')                                                    */
/*********************************************************************/
/*                                                                   */
/*                                                                   */
/*********************************************************************/
             CMD        PROMPT('IFSAUTLC')

             PARM       KWD(PATH) TYPE(*CHAR) LEN(100) MIN(1) +
                          PROMPT('FILE')

