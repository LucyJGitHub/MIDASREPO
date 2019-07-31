     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas AP Data substitution')
      *****************************************************************
      *                                                               *
      *  Midas - API Interface Module                                 *
      *                                                               *
      *  APDTASUBS - Midas API Data Substitution                      *
      *                                                               *
      *  Function:  This program replaces a substitution character    *
      *             found in an incoming message with the data present*
      *             in the current screen image of the message.       *
      *                                                               *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.02 -----------------------------------------------*
      *  Prev Amend No. CAP011  *CREATE    Date 07Sep99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CAP011 - Substitution of Midas database flds for externl i/fs*
      *                                                               *
      *****************************************************************
      /EJECT
 
     D                 DS
     D  a_IncDATA              1   2000
     D                                     DIM(2000)
 
 
     C     *ENTRY        PLIST
      * Return Code
     C                   PARM                    ReturnCode       10
      * Substitution character
     C                   PARM                    SubsChar          1
      * Incoming Data
     C                   PARM                    IncDATA        2000
      * Current Data
     C                   PARM                    CurDATA        2000
 
      * Early exit if no substitution character
 
     C     SubsChar      ifeq      *blank
     C                   return
     C                   endif
 
      * Move incoming message into search array
 
     C                   movea     IncDATA       a_IncDATA
 
      * Look for control character in search array
      * Where found substitute corresponding character in current message
 
     C                   z-add     1             @p                5 0
     C     SubsChar      lookup    a_IncDATA(@p)                          99
     C     *in99         doweq     '1'
     C     1             subst     CurDATA:@p    @s                1
     C                   move      @s            a_IncDATA(@p)
     C                   add       1             @p
     C     SubsChar      lookup    a_IncDATA(@p)                          99
     C                   enddo
 
      * Update returned data
 
     C                   movea     a_IncDATA     IncDATA
 
     C                   RETURN
 
      ********************************************************************
