     h nomain

      *****************************************************************
/**** *  RPGBASEMOD                                                   *                     MD058082
/*STD *  RPGSQLMOD                                                    *                     MD058082
/*EXI *  CLOSQLCSR(*ENDMOD)                                           *                     MD058082
/*EXI *  TEXT('Midas FRS Return pay/receive flag')
      *****************************************************************
      *                                                               *
      *  Midas - FRS Regulatory Reporting                             *
      *                                                               *
      *  RNPAYREC   - Return Pay/Receive flag                         *
      *                                                               *
      *  (c) Finastra International Limited 2005                      *
      *                                                               *
      *  Last Amend No. MD058082           Date 21Jan21               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CRN001  *CREATE    Date 26Sep05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD058082 - Deliverable Data Split for FRS                    *
      *  MD046248 - Finastra Rebranding                               *
      *  CRN001 - FRS Regulatory Reporting                            *
      *                                                               *
      *****************************************************************
     f*rnkyprpd* if   e           k disk    usropn                                          MD058082
     f**********                           prefix(p_)                                       MD058082

     d                 ds
     d aPayRec                             dim(9999)
     d  acctKey                            like(p_rnkey)
     d                                     overlay(aPayRec)
     d  payRec                             like(p_rnpayrec)
     d                                     overlay(aPayRec: *next)

     d elm             s              5u 0                                      no. of array entries
     d elmIx           s              5u 0                                      arrary index

     D RNKYPR        E DS                  EXTNAME(RNKYPJW0)                                MD058082
     D                                     prefix(p_)                                       MD058082
      /copy rncpysrc,rnpayrec

      *=====================================================================

     p rnPayRec        b                   export

     d                 pi                  like(p_rnPayRec)
     d acctKeyIn                           like(p_rnkey) const

      *---------------------------------------------------------------------

     c                   eval      elmIx =  0

     c                   eval      elmIx =  %lookup(acctKeyIn
     c                                      : acctKey
     c                                      : 1
     c                                      : elm )
     c                   select
     c                   when      elmIx > 0
     c                   return    payRec(elmIx)

     c                   other
     c                   return    '*'
     c                   endsl

     p                 e

      *=====================================================================

     p rnPayRecIn      b                   export

     c**********         if        not %open(rnkyprpd)                                      MD058082
     c**********         open      rnkyprpd                                                 MD058082
     c**********         endif                                                              MD058082

     c******loval        setll     rnkyprpd                                                 MD058082
     c**********         read      rnkyprpd                                                 MD058082
     C/EXEC SQL                                                                             MD058082
     C+ close ACursor                                                                       MD058082
     C/END-EXEC                                                                             MD058082
                                                                                            MD058082
     C/EXEC SQL                                                                             MD058082
     C+ declare ACursor insensitive scroll cursor for                                       MD058082
     C+ select * from RNKYPJW0                                                              MD058082
     C+ order by RNKEY                                                                      MD058082
     C/END-EXEC                                                                             MD058082
                                                                                            MD058082
     C/EXEC SQL                                                                             MD058082
     C+ open ACursor                                                                        MD058082
     C/END-EXEC                                                                             MD058082
                                                                                            MD058082
     C/EXEC SQL                                                                             MD058082
     C+ fetch next from ACursor into :RNKYPR                                                MD058082
     C/END-EXEC                                                                             MD058082
                                                                                            MD058082

     c                   eval      elm         = 0

     c**********         dow       not %eof                                                 MD058082
     c                   dow       SQLCODE = 0                                              MD058082
     c                   eval      elm          += 1
     c                   eval      acctKey(elm)  = p_rnkey
     c                   eval      payRec(elm)   = p_rnpayrec

     c**********         read      rnkyprpd                                                 MD058082
     C/EXEC SQL                                                                             MD058082
     C+ fetch next from ACursor into :RNKYPR                                                MD058082
     C/END-EXEC                                                                             MD058082
     c                   enddo

     c**********         close     rnkyprpd                                                 MD058082

     p                 e
