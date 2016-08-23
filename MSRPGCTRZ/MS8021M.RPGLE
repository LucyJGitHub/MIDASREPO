     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MS CASmf session selection           *MODULE')
      *****************************************************************
      *                                                               *
      *  Midas SWIFT Direct link : Midas/CAS interface                *
      *                                                               *
      *  MS8021M - CASmf session selection                            *
      *                                                               *
      *  Function:  This program is used to select a CASmf session    *
      *             for a particular Midas system.                    *
      *                                                               *
      *  Called By: MS8020M - CASmf session maintenance               *
      *                                                               *
      *  Calls    :                                                   *
      *                                                               *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *  Last Amend No. CSW008 *CREATE     Date 04OCT96               *
      *  Prev Amend No.                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSW008 - Midas/CAS interface                                 *
      *  nnnnnn - (fix details)                                       *
      *                                                               *
      *****************************************************************
      /EJECT
     FMS8021DF  CF   E             workstn
     F                                     sfile(ms8021f2:w@rrn)
     F                                     infds(d@infds)
      /EJECT
     D rundat        E DS            13
      ** Rundate data area
      *
     D dspgm         ESDS                  extname(y2pgdsp)
      *  Program status data structure
      *
     D d@infds         DS
     D  w@lstrn              378    379B 0
      **  Last subfile start RRN
      *
     D arr1            S             26A   dim(40)
      ** Array of L-MAPIDs from CASmf
      *
      *****************************************************************
      *  Index to Subroutines                                         *
      *                                                               *
      *  sr_init       : Initialise program and subfile               *
      *  sr_enter      : Enter key processing                         *
      *  sr_loadsfl    : Load subfile                                 *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** Receive parameters from MS8020M
     C     *entry        plist
     C                   parm                    arr1
     C                   parm                    r@sesn           26
     C                   parm                    rc               10
      *
      ** Perform initial process
     C                   exsr      sr_init
      *
      ** Write headings
     C                   write     ms8021f1
     C                   write     ms8021f4
      *
      ** Load subfile
     C                   exsr      sr_loadsfl
      *
      ** Display screen until F12 or valid selection
     C     *in12         doueq     *on
     C     r@sesn        orne      *blanks
      *
      ** Write detail; subfile or 'no details to report'
     C     x             ifgt      1
     C                   write     sflmsgc
     C                   seton                                        555657
     C                   exfmt     ms8021f3
     C                   else
     C                   exfmt     ms8021f5
     C                   movel     *on           *in12
     C                   endif
      *
      ** If enter pressed on details screen, validate
     C     *in12         ifeq      *off
     C                   exsr      sr_enter
     C                   endif
      *
     C                   enddo
      *
      **  Return to calling program
     C                   seton                                        LR
      /EJECT
      **********************************************************************
      * sr_enter       : Process enter key                                 *
      * --------                                                           *
      *                                                                    *
      * Called by      : mainline                                          *
      *                                                                    *
      * Calls          : ZM1001 - Send message                             *
      *                                                                    *
      **********************************************************************
      *
     C     sr_enter      begsr
      *
      ** Set up value for return
     C                   z-add     1             w@dsp             5 0
     C                   call      'ZM1002'
      *
      ** Read changed subfile records
     C                   readc     ms8021f2                               42
     C     *in42         doweq     '0'
     C     s2selt        andne     '1'
      *
     C                   movel     *off          *in30
     C     s2selt        ifne      ' '
     C     w@dsp         ifeq      1
     C                   z-add     w@rrn         w@dsp
     C                   endif
     C                   movel     'MEM6022'     p@msgid
     C                   call      'ZM1001'      p@snmsg
     C                   move      *on           *in30
     C                   endif
      *
     C                   move      *on           *in24
     C                   update    ms8021f2
     C                   readc     ms8021f2                               42
     C                   enddo
      *
      ** Position subfile to first field in error
     C                   z-add     w@dsp         DSPREC
      *
      ** For valid selection return session to calling program
     C     s2selt        ifeq      '1'
     C                   movel(p)  s2sesn        r@sesn
     C                   endif
      *
     C                   endsr
      /EJECT
      **********************************************************************
      * sr_loadsfl     : Load subfile                                      *
      * ----------                                                         *
      *                                                                    *
      * Called by      : Mainline                                          *
      *                                                                    *
      * Calls          :   --                                              *
      *                                                                    *
      **********************************************************************
      *
     C     sr_loadsfl    begsr
      *
      ** Initialise subfile details
     C                   z-add     1             x                 5 0
     C                   z-add     1             w@rrn             5 0
     C                   clear                   ms8021f3
     C                   setoff                                       5556
     C                   write     ms8021f4
     C                   movea(p)  arr1(x)       s2sesn
      *
      ** While records exist, fill subfile page
     C     s2sesn        downe     *blank
     C     x             andle     40
      *
      ** Write in subfile
     C                   write     ms8021f2
      *
      ** Get next record
     C                   add       1             x
     C                   add       1             w@rrn
     C                   movea(p)  arr1(x)       s2sesn
     C                   enddo
      *
      ** Display from start of subfile
     C                   z-add     1             DSPREC
      *
     C                   endsr
      /EJECT
      **********************************************************************
      * sr_init        : Initial processing                                *
      * -------                                                            *
      *                                                                    *
      * Called by      : Mainline                                          *
      *                                                                    *
      * Calls          : ZM1002 - Clear message subfile                    *
      *                                                                    *
      **********************************************************************
      *
     C     sr_init       begsr
      *
      ** Definitions
     C     p@snmsg       plist
     C                   parm                    p@msgid          10
     C                   parm                    p@msdta          78
      *
      ** Define RUNDAT data area
     C     *dtaara       define                  rundat
     C                   in        rundat
      *
      ** Clear message subfile
     C                   call      'ZM1002'
      *
     C                   endsr
