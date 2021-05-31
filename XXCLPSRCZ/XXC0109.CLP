/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas SE SSI Authorisation Check')                    */
/*********************************************************************/
/*                                                                   */
/*       Midas - Securities Trading Module                           */
/*                                                                   */
/*       XXC0109 - Midas SE SSI Authorisation Check                  */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. HUT109  *CREATE    Date 14Apr20              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       HUT109 - Partial upgrade of HUT020 to FBM 2.1 SP22.         */
/*                Additional Authorisation Steps in SE Module        */
/*                                                                   */
/*********************************************************************/

             Pgm        Parm(&PRM01 &RSEQ &RLEV &RENT)

             Dcl        Var(&CPYFLD) Type(*CHAR) Len(64) Value('(c) +
                          Finastra International Limited +
                          2001')

             Dcl        Var(&RSEQ)  Type(*CHAR) Len(5)
             Dcl        Var(&RLEV)  Type(*CHAR) Len(1)
             Dcl        Var(&RENT)  Type(*CHAR) Len(3)
             Dcl        Var(&PRM01) Type(*CHAR) Len(8)
             Dcl        Var(&LDA)   Type(*CHAR) Len(256)
             Dcl        Var(&MEM)   Type(*CHAR) Len(50)
             Dcl        Var(&MSG)   Type(*CHAR) Len(60)
             Dcl        Var(&FKEY)  Type(*CHAR) Len(4)

/* Set up LDA in QTEMP */
             CrtDtaAra  DtaAra(QTEMP/LDA) Type(*CHAR) Len(256)
             MonMsg     MsgId(CPF1023)

/* Create key to position files */
             ChgVar  Var(&FKEY) Value(&RLEV *CAT &RENT)

/* Set up pgm message */
             If         Cond(&PRM01 *EQ 'XX0109  ') Then(DO)
                ChgVar     Var(&MSG) +
                           VALUE('XX0109 - SSI AUTHORISATION CHECK')

/* Position file to the particular branch */
                If         Cond((&RENT *NE '   ') +
                           *AND (&RENT *NE 'ALL')) Then(DO)
                   OvrDbF     File(XXXSEDV2) +
                              Position(*KEY 1 XXXSEDT0 &RENT)

                   OpnDbF     File(XXXSEDV2) Option(*ALL)
                   MonMsg     MsgId(CPF0000) Exec(DO)
                      DltOvr     File(XXXSEDV2)
                   EndDo

                   CloF       OpnId(XXXSEDV2)
                   MonMsg     MsgId(CPF0000)
                EndDo
             EndDo

/* Send pgm message */
             SndPgmMsg  MSG(&MSG) ToMsgQ(MRUNQ) MsgType(*INFO)

/* Clear switches */
             ChgJob     Sws(00000000)

/* Call the program */
             Call       Pgm(&PRM01) Parm('I' &RSEQ &RENT)

/* For database errors recover data from LDA */
ERROR:       If         Cond(%SWITCH(XXXXXX11)) Then(DO)
                RtvDtaAra  DtaAra(LDA) RtnVar(&LDA)
                ChgVar     Var(&MEM) Value(%SUBSTRING(&LDA 134 50))
                SndPgmMsg  MsgId(MEM0001) MsgF(MIDAS) MsgDta(&MEM)-
                           ToPgmQ(*EXT) ToMsgQ(MOPERQ MRUNQ)
                ChgVar     Var(&MEM) Value('XXC0109 - JOB TERMINATED, +
                          DATABASE IN ERROR')
                SndPgmMsg  Msg(&MEM) ToPgmQ(*EXT) +
                           ToMsgQ(MOPERQ MRUNQ)
             EndDo

ENDPGM:      ChgVar     Var(&CPYFLD) Value('(c) +
                          Finastra International Limited 2001 ')
             EndPgm
